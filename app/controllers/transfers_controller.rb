class TransfersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_transfer, only: %i[show edit update destroy external_edit]
  require 'prawn'
  require 'prawn/table'
  #authorize_resource

  # GET /transfers
  def index
    @event_name = params[:event_name]
    @role       = params[:role]
  
    @transfers =
      if @event_name.present?
        Transfer.joins(:event, :person)
                .where(events: { name: @event_name })
                .order('people.first_name ASC')
      else
        Transfer.joins(:event, :person)
                .where(events: { name: 'US Open 2025 - Austin' })
                .order('people.first_name ASC')
      end
  
    # Add role filter if selected
    @transfers = @transfers.where(role: @role) if @role.present?
  
    # Build roles list for dropdown
    @roles = Transfer.distinct.where.not(role: [nil, ""]).order(:role).pluck(:role)
  end
  

  def inbound_pickups
    @event_name = 'US Open 2025 - Austin'
    event_id = Event.find_by(name: @event_name)&.id
  
    @transfers = Transfer
                   .includes(:person)
                   .where(event_id: event_id)
                   .where(arrival_airport_transport_request: "Yes - Requesting transport")
                   .order(:arrival_time)
  
    @transfers_by_date = @transfers.group_by(&:arrival_date_only)
  end
  
  def outbound_pickups
    @event_name = 'US Open 2025 - Austin'
    event_id = Event.find_by(name: @event_name)&.id
  
    @transfers = Transfer
                   .includes(:person)
                   .where(event_id: event_id)
                   .where(departure_airport_transport_request: "Yes - Requesting transport")
                   .order(:departure_time)
  
    @transfers_by_date = @transfers.group_by(&:departure_date_only)
  end
  
  
  # GET /transfers/1
  def show
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
    @events = Event.where(event_type: "US Open").where("date >= ?", Date.today.beginning_of_month).ordered
    @people = Person.active.ordered
  end

  # GET /transfers/1/edit
  def edit
    @events = Event.where(event_type: "US Open").where("date >= ?", Date.today.beginning_of_month).ordered
    @people = Person.active.ordered
    @sonya_message = SampleWord.find_by(category: "US Open 2025 Austin")&.desc

  end

   def external_edit #added to show Sonya the view
    @events = Event.where(event_type: "US Open").where("date >= ?", Date.today.beginning_of_month).ordered
    @people = Person.active.ordered
    @transfer = Transfer.find(params[:id])
  end

  # POST /transfers
  def create
    @events = Event.where(event_type: "US Open").where("date >= ?", Date.today.beginning_of_month).ordered
        @people = Person.active.ordered

    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      redirect_to @transfer, notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transfers/1
  def update
    @events = Event.where(event_type: "US Open").where("date >= ?", Date.today.beginning_of_month).ordered
        @people = Person.active.ordered

    if @transfer.update(transfer_params)
      redirect_to @transfer, notice: "Transfer was successfully updated.", status: :see_other
    else
      #Rails.logger.info @transfer.errors.full_messages.join(",")
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transfers/1
  def destroy
    @transfer.destroy
    redirect_to transfers_url, notice: "Transfer was successfully destroyed.", status: :see_other
  end
  
  def download_transfers_in_sheet_pdf
    respond_to do |format|
      format.pdf do
        begin
          pdf_data = TransferPdfGenerator.new.generate
          send_data pdf_data, filename: 'transfer_sheet.pdf', type: 'application/pdf', disposition: 'inline'
        rescue => e
          Rails.logger.error("PDF generation failed: #{e.message}")
          flash[:error] = "There was an error generating the PDF. Please alert tech support at techsupport@netballamerica.com."
          redirect_to inbound_pickups_transfers_path
        end
      end
    end
  end
  
  def download_transfers_out_sheet_pdf
    respond_to do |format|
      format.pdf do
        begin
          pdf_data = ::DeparturePdfGenerator.new(start_date: Date.parse(params[:value])).generate
          send_data pdf_data, filename: 'transfer_sheet.pdf', type: 'application/pdf', disposition: 'inline'
        rescue => e
          Rails.logger.error("PDF generation failed: #{e.message}")
          flash[:error] = "There was an error generating the PDF. Please alert tech support at techsupport@netballamerica.com."
          redirect_to outbound_pickups_transfers_path
        end
      end
    end
  end

  def download_uniforms_pdf
    respond_to do |format|
      format.pdf do
        begin
          pdf_data = UniformPdfGenerator.new.generate
          send_data pdf_data, filename: 'uniforms_and_tshirts.pdf', type: 'application/pdf', disposition: 'inline'
        rescue => e
          Rails.logger.error("PDF generation failed: #{e.message}")
          flash[:error] = "There was an error generating the Uniform PDF. Please alert tech support."
          redirect_to transfers_path
        end
      end
    end
  end

  def download_attendee_list_pdf
    event_name = params[:event_name].presence || latest_event_name
  
    respond_to do |format|
      format.pdf do
        begin
          pdf_data = AttendeeListPdfGenerator.new(event_name: event_name).generate
          send_data pdf_data, filename: 'attendee_list_by_role.pdf', type: 'application/pdf', disposition: 'inline'
        rescue => e
          Rails.logger.error("Attendee List PDF generation failed: #{e.message}")
          flash[:error] = "There was an error generating the attendee list PDF. Please contact support."
          redirect_to transfers_path
        end
      end
    end
  end

  # app/controllers/transfers_controller.rb
  def download_flights_pdf
    respond_to do |format|
      format.pdf do
        begin
          pdf_data = FlightDetailsPdfGenerator.new.generate
          send_data pdf_data,
                    filename: 'flight_details.pdf',
                    type: 'application/pdf',
                    disposition: 'inline'
        rescue => e
          Rails.logger.error("Flight Details PDF generation failed: #{e.message}")
          flash[:error] = "There was an error generating the Flight Details PDF. Please alert tech support."
          redirect_to transfers_path
        end
      end
    end
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer
      @transfer = Transfer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transfer_params
      params.require(:transfer).permit(:id, :person_id, :event_id, :consent, :role, :obtain_headshot, 
      :arrival_airport_transport_request, :departure_airport_transport_request, :arrival_phone, :departure_phone, 
      :grouping_pickup_time, :grouping_departure_time, :departure_meetup_location, :hotel_confirmation_personal, :dietary_requirements_allergies,
      :hotel_arrival, :hotel_departure, :check_in, :check_out, :room_type, :hotel_reservation, :share_volunteer, 
      :arrival_airline, :arrival_flight, :arrival_terminal, :arrival_time, 
      :departure_airline, :departure_flight, :departure_terminal, :departure_time, :transfer_departure_type,
      :notes, :hotel_name, :pick_up_grouping, :pickup_type, :pickup_location, :pickup_note, :departure_grouping, :departure_type, :departure_note, 
      :t_shirt_size, :visa_type, :umpire_badge_level, :certification_date,  :headshot, :certification, :event_title, :registration_form_completed, :waiver_form_completed, :read_and_agreed_tcs, 
      person_attributes: 
      [ :id, :level_submitted, :associated, :gender, :tshirt_size, :inferno_top_polo_size,
      :inferno_top_vneck_size, :inferno_bottom_skirt_size, :inferno_bottom_shorts_size, :certification, :certification_date, :headshot ] )
    end

    def latest_event_name
      'US Open 2025 - Austin'
    end
end

