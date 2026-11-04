class EventTransportsController < ApplicationController
  TRANSFER_EVENT_ID = 291

  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_transfer_event
  before_action :set_event_transport, only: %i[show edit update destroy]
  before_action :set_registered_people, only: %i[new create edit update]

  def index
    @event_transports = EventTransport
                        .includes(event_transport_passengers: :person)
                        .where(transfer_event_id: @transfer_event.id)
                        .scheduled
    @event_transports_by_date = @event_transports.group_by { |transport| transport.departure_at.to_date }
  end

  def show; end

  def new
    @event_transport = EventTransport.new(transfer_event: @transfer_event)
    8.times { @event_transport.event_transport_passengers.build }
  end

  def edit
    build_write_in_rows
  end

  def create
    @event_transport = EventTransport.new(event_transport_params)
    @event_transport.transfer_event = @transfer_event
    sync_registered_passengers

    if @event_transport.save
      redirect_to event_transports_path, notice: "Event transport was successfully created."
    else
      build_write_in_rows
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @event_transport.assign_attributes(event_transport_params)
    @event_transport.transfer_event = @transfer_event
    sync_registered_passengers

    if @event_transport.save
      redirect_to event_transports_path, notice: "Event transport was successfully updated."
    else
      build_write_in_rows
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event_transport.destroy
    redirect_to event_transports_path,
                notice: "Event transport was successfully deleted.",
                status: :see_other
  end

  def pdf
    pdf_data = EventTransportPdfGenerator.new(transfer_event_id: @transfer_event.id).generate
    send_data pdf_data,
              filename: "event_transport.pdf",
              type: "application/pdf",
              disposition: "inline"
  rescue StandardError => e
    Rails.logger.error("Event Transport PDF generation failed: #{e.message}")
    redirect_to event_transports_path,
                alert: "There was an error generating the Event Transport PDF."
  end

  private

  def set_event_transport
    @event_transport = EventTransport.where(transfer_event_id: @transfer_event.id).find(params[:id])
  end

  def set_transfer_event
    @transfer_event = Event.find(TRANSFER_EVENT_ID)
  end

  def set_registered_people
    @registered_people = Person
                         .joins(:transfers)
                         .where(transfers: { event_id: @transfer_event.id })
                         .distinct
                         .order(:first_name, :last_name)
  end

  def event_transport_params
    params.require(:event_transport).permit(
      :departure_at,
      :arrival_at,
      :pickup_location,
      :destination,
      :driver_name,
      :notes,
      event_transport_passengers_attributes: %i[id write_in_name phone _destroy]
    )
  end

  def sync_registered_passengers
    submitted_params = params[:registered_passengers]
    submitted = submitted_params.respond_to?(:to_unsafe_h) ? submitted_params.to_unsafe_h : {}
    submitted.select! { |_person_id, values| values["selected"] == "1" }
    permitted_person_ids = @registered_people.map { |person| person.id.to_s }
    submitted.slice!(*permitted_person_ids)

    existing = @event_transport.event_transport_passengers
                               .select { |passenger| passenger.person_id.present? }
                               .index_by { |passenger| passenger.person_id.to_s }

    existing.each do |person_id, passenger|
      passenger.mark_for_destruction unless submitted.key?(person_id)
    end

    submitted.each do |person_id, values|
      person = @registered_people.find { |candidate| candidate.id.to_s == person_id }
      next unless person

      passenger = existing[person_id] || @event_transport.event_transport_passengers.build(person: person)
      submitted_phone = values.fetch("phone", "").strip
      passenger.phone = submitted_phone == person.phone.to_s.strip ? nil : submitted_phone.presence
    end
  end

  def build_write_in_rows
    missing_rows = 8 - @event_transport.event_transport_passengers.count do |passenger|
      passenger.person_id.blank? && !passenger.marked_for_destruction?
    end
    missing_rows.times { @event_transport.event_transport_passengers.build } if missing_rows.positive?
  end
end
