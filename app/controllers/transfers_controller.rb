class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only:[:show, :edit, :update, :index]
  require 'prawn'
  require 'prawn/table'

  # GET /transfers
  def index
    @transfers_priority= Transfer.all.ordered
    @transfers = Transfer.includes(:person).order('people.first_name')
  
  end

  def index_inbound_pickup
    @no_transfers = Transfer.where(no_pick_up: false)
    @transfers = Transfer.where(no_pick_up: true). where("arrival_time IS NOT NULL")
   
    @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
    @transfers_by_arrival_date_only = @transfers.group_by { |t| t.arrival_date_only }
  end
  
  def index_outbound_pickup
    @no_transfers = Transfer.where(no_pick_up: false)
    @transfers = Transfer.where(no_pick_up: true).where("departure_time IS NOT NULL")
    
    @transfers = @transfers.order(departure_time: :asc).order(departure_airline: :asc)
    @transfers_by_departure_date_only = @transfers.group_by { |t| t.departure_date_only }
  end
  
  # GET /transfers/1
  def show
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
    @events= Event.where(event_type: "US Open").ordered
    @people = Person.all.ordered
  end

  # GET /transfers/1/edit
  def edit
    @events= Event.where(event_type: "US Open").ordered
    @people = Person.all.ordered

  end

  # POST /transfers
  def create
    @events= Event.where(event_type: "US Open").ordered
    @people = Person.all.ordered
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      redirect_to @transfer, notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transfers/1
  def update
    @events= Event.where(event_type: "US Open").ordered
    @people = Person.all.ordered
    if @transfer.update(transfer_params)
      redirect_to @transfer, notice: "Transfer was successfully updated.", status: :see_other
    else
      Rails.logger.info @transfer.errors.full_messages.join(",")
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transfers/1
  def destroy
    @transfer.destroy
    redirect_to transfers_url, notice: "Transfer was successfully destroyed.", status: :see_other
  end
  
   def download_transfers_in_sheet_pdf
     
     @start_date = Date.today.beginning_of_year # Current vacation calendar year
     @transfers = Transfer.where(no_pick_up: true).where("arrival_time IS NOT NULL")
     @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
     @transfers_by_arrival_date_only = @transfers.group_by { |t| t.arrival_date_only }
   
       respond_to do |format|
         format.pdf do
          #DOCUMENT SETUP_START
            pdf = Prawn::Document.new()  
            pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", :at => [462,737], :width => 80 
            pdf.text ":: NETBALL AMERICA :: US Open "+  @start_date.to_datetime.strftime('%Y') +"\n", size: 6
            pdf.text "Arrivals Transfers Sheet", size: 14, style: :bold, align: :center
            pdf.text "Print Date: "+Date.today.to_datetime.strftime('%b %d, %Y')+"\n", size: 6, align: :right
            pdf.text "\n", size: 6  
          #DOCUMENT SETUP_END  
        
          #DATE_HEADER_START
          @transfers_by_arrival_date_only.each do |arrival_date_only, transfers|
             pdf.text transfers.first.arrival_time.strftime('%A') + "   "+ arrival_date_only, size: 12
                transfer_table_data = Array.new
                transfer_table_data << ["GP", "Name", "Phone", "Arrv. Time", "Flight", "Airline & Term.", "PickUp", "Pick Up Location", "Hotel", "Notes" ]
                transfers.each do |transfer|
                  transfer_table_data << [transfer.pick_up_grouping, transfer.person.full_name, transfer.phone, transfer.arrival_time.to_datetime.strftime('%H:%M'), transfer.arrival_flight, transfer.arrival_airline_and_terminal, transfer.pickup_type, transfer.pickup_location, transfer.hotel_name, transfer.pickup_note]
                  end
             pdf.table(transfer_table_data) do 
                self.width = 520
                self.cell_style = { :inline_format => true, size: 6 } 
                {:borders => [:top, :left, :bottom, :right],
                :border_width => 1,
                :border_color => "B2BEB5"}
                row(0).font_style = :bold
                columns(0).width = 20
                columns(1).width = 70
                columns(2).width = 40
                columns(3).width = 25
                columns(4).width = 35
                columns(5).width = 60
                columns(6).width = 50
                columns(7).width = 50
                columns(8).width = 80
                columns(8).width = 80
                columns(0).align = :left
                columns(1).align = :left
                columns(2).align = :right
                columns(3).align = :right
                columns(4).align = :right
              end
   
            pdf.text "\n", size: 6  
            pdf.text "\n", size: 6  
          end   
        
          send_data pdf.render, filename: 'transfer_sheet.pdf', type: 'application/pdf', :disposition => 'inline'
       end
     end
   end
  
  
  
   def download_transfers_out_sheet_pdf 
     
     @start_date = Date.today.beginning_of_year # Current vacation calendar year
     @transfers = Transfer.where(no_pick_up: true).where("departure_time IS NOT NULL")
     @transfers = @transfers.order(departure_time: :asc).order(departure_airline: :asc)
     @transfers_by_departure_date_only = @transfers.group_by { |t| t.departure_date_only }
   
       respond_to do |format|
         format.pdf do
          #DOCUMENT SETUP_START
            pdf = Prawn::Document.new()  
            pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", :at => [462,737], :width => 80 
            pdf.text ":: NETBALL AMERICA :: US Open "+  @start_date.to_datetime.strftime('%Y') +"\n", size: 6
            pdf.text "Departures Transfers Sheet", size: 14, style: :bold, align: :center
            pdf.text "Print Date: "+Date.today.to_datetime.strftime('%b %d, %Y')+"\n", size: 6, align: :right
            pdf.text "\n", size: 6  
          #DOCUMENT SETUP_END  
        
          #DATE_HEADER_START
          @transfers_by_departure_date_only.each do |departure_date_only, transfers|
             pdf.text transfers.first.departure_time.strftime('%A') + "   "+ departure_date_only, size: 12
                transfer_table_data = Array.new
                transfer_table_data << ["Grouping", "Name", "Phone", "Dep. Time", "Flight", "Airline & Term.", "PickUp", "Hotel", "Notes" ]
                transfers.each do |transfer|
                  transfer_table_data << [transfer.departure_grouping, transfer.person.full_name, transfer.phone, transfer.departure_time.to_datetime.strftime('%H:%M'), transfer.departure_flight, transfer.departure_airline_and_terminal, transfer.departure_type, transfer.hotel_name, transfer.departure_note]
                  end
             pdf.table(transfer_table_data) do 
                self.width = 545
                self.cell_style = { :inline_format => true, size: 6 } 
                {:borders => [:top, :left, :bottom, :right],
                :border_width => 1,
                :border_color => "B2BEB5"}
                row(0).font_style = :bold
                columns(0).width = 40
                columns(1).width = 90
                columns(2).width = 50
                columns(3).width = 30
                columns(4).width = 35
                columns(5).width = 60
                columns(6).width = 60
                columns(7).width = 80
                columns(8).width = 100
                columns(0).align = :left
                columns(1).align = :left
                columns(2).align = :right
                columns(3).align = :right
                columns(4).align = :right
              end
   
            pdf.text "\n", size: 6  
            pdf.text "\n", size: 6  
          end   
        
          send_data pdf.render, filename: 'transfer_sheet.pdf', type: 'application/pdf', :disposition => 'inline'
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
      params.require(:transfer).permit(:id, :person_id, :event_id, :consent, :role, :hotel_arrival, :hotel_departure, :check_in, :check_out, :room_type, :hotel_reservation, :share_volunteer, :arrival_airline, :arrival_flight, :arrival_terminal, :arrival_time, :departure_airline, :departure_flight, :departure_terminal, :departure_time, :no_pick_up, :notes, :phone, :hotel_name, :pick_up_grouping, :pickup_type, :pickup_location, :pickup_note, :departure_grouping, :departure_type, :departure_note, :t_shirt_size, :visa_type, :umpire_badge_level, :certification_date,  :headshot, :certification, :event_title, :registration_form_completed, :waiver_form_completed, :read_and_agreed_tcs, 
      person_attributes: [ :id, :level_submitted, :associated, :gender, :tshirt_size, :uniform_size, :certification, :certification_date, :headshot ] )
    end
end

