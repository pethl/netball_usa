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
      
      # Fetch Transfers with optional filtering by event_name
      @transfers = if @event_name.present?
        Transfer.joins(:event, :person).where(events: { name: @event_name }).order('people.first_name ASC')
      else
        Transfer.joins(:event, :person).where(events: { name: 'US Open 2025 - Austin' }).order('people.first_name ASC')
      end
    
  end

  def inbound_pickups
    @no_transfers = Transfer.joins(:event).where(events: { name: 'US Open 2025 - Austin' }).where(airport_transport_request: "No - Have own transport")
    @transfers = Transfer.joins(:event).where(events: { name: 'US Open 2025 - Austin' }).where(airport_transport_request: "Yes - Requesting transport")
   
    @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
    @transfers_by_date = @transfers.group_by { |t| t.arrival_date_only }
  end
  
  def outbound_pickups
    @no_transfers = Transfer.joins(:event).where(events: { name: 'US Open 2025 - Austin' }).where(airport_transport_request: "No - Have own transport")
    @transfers = Transfer.joins(:event).where(events: { name: 'US Open 2025 - Austin' }).where(airport_transport_request: "Yes - Requesting transport")
    
    @transfers = @transfers.order(departure_time: :asc).order(departure_airline: :asc)
    @transfers_by_date = @transfers.group_by { |t| t.departure_date_only }
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
          redirect_to transfers_url
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
          redirect_to transfers_url
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
      params.require(:transfer).permit(:id, :person_id, :event_id, :consent, :role, :obtain_headshot, :airport_transport_request, :grouping_pickup_time, :grouping_departure_time, :departure_meetup_location, :hotel_confirmation_personal, :dietary_requirements_allergies,
      :hotel_arrival, :hotel_departure, :check_in, :check_out, :room_type, :hotel_reservation, :share_volunteer, :arrival_airline, :arrival_flight, :arrival_terminal, :arrival_time, :departure_airline, :departure_flight, :departure_terminal, :departure_time, :no_pick_up, :notes, :phone, :hotel_name, :pick_up_grouping, :pickup_type, :pickup_location, :pickup_note, :departure_grouping, :departure_type, :departure_note, :t_shirt_size, :visa_type, :umpire_badge_level, :certification_date,  :headshot, :certification, :event_title, :registration_form_completed, :waiver_form_completed, :read_and_agreed_tcs, 
      person_attributes: [ :id, :level_submitted, :associated, :gender, :tshirt_size, :uniform_size, :certification, :certification_date, :headshot ] )
    end
end

