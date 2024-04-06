class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only:[:show, :create, :edit, :update, :index]
  require 'prawn'
  require 'prawn/table'

  # GET /transfers
  def index
    @transfers = Transfer.all.order(first_name: :asc)
  end

  def index_inbound_pickup
    @no_transfers = Transfer.where(no_pick_up: false)
    @transfers = Transfer.where(no_pick_up: true). where("arrival_time IS NOT NULL")
   
    @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
    @transfers_by_arrival_date_only = @transfers.group_by { |t| t.arrival_date_only }
  end
  
  def index_outbound_pickup
    @transfers = Transfer.all.order(departure_time: :asc).order(arrival_airline: :asc)
    @transfers_by_departure_date_only = @transfers.group_by { |t| t.departure_date_only }
  end
  
  # GET /transfers/1
  def show
  end

  # GET /transfers/new
  def new
    @transfer = Transfer.new
  end

  # GET /transfers/1/edit
  def edit
  end

  # POST /transfers
  def create
    @transfer = Transfer.new(transfer_params)

    if @transfer.save
      redirect_to @transfer, notice: "Transfer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /transfers/1
  def update
    if @transfer.update(transfer_params)
      redirect_to @transfer, notice: "Transfer was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /transfers/1
  def destroy
    @transfer.destroy
    redirect_to transfers_url, notice: "Transfer was successfully destroyed.", status: :see_other
  end
  
   def download_transfers_sheet_pdf
     
     @start_date = Date.today.beginning_of_year # Current vacation calendar year
     @end_date = Date.today.end_of_year # Current vacation calendar year - end
     
     @transfers = Transfer.where(no_pick_up: true). where("arrival_time IS NOT NULL")
     @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
     @transfers_by_arrival_date_only = @transfers.group_by { |t| t.arrival_date_only }
   
     respond_to do |format|
       format.pdf do
        #DOCUMENT SETUP_START
       pdf = Prawn::Document.new()  
        pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", :at => [10,10], :width => 100 
        pdf.text "Print Date: "+Date.today.to_datetime.strftime('%b %d, %Y')+"\n", size: 6, align: :right
        pdf.text ":: NETBALL AMERICA :: US Open "+  @start_date.to_datetime.strftime('%Y') +"\n", size: 6
        pdf.text "Transfers Sheet", size: 14, style: :bold, align: :center
        pdf.text "\n", size: 6  
        #DOCUMENT SETUP_END  
        
        #DATE_HEADER_START
        @transfers_by_arrival_date_only.each do |arrival_date_only, transfers|
           pdf.text transfers.first.arrival_time.strftime('%A') + "   "+ arrival_date_only, size: 12
         
           # pdf.text "Front of House", size: 10, style: :bold 
 
              transfer_table_data = Array.new
              transfer_table_data << ["Grouping", "Name", "Phone", "Arrv. Time", "Flight", "Airline", "PickUp", "Hotel", "Notes" ]
              transfers.each do |transfer|
                
                transfer_table_data << [transfer.pick_up_grouping, transfer.full_name, transfer.phone, transfer.arrival_time.to_datetime.strftime('%H:%M'), transfer.arrival_flight, transfer.arrival_airline, transfer.pickup_type, transfer.hotel_name, transfer.pickup_note]
            end
            pdf.table(transfer_table_data) do 
              self.width = 555
              self.cell_style = { :inline_format => true, size: 6 } 
               row(0).font_style = :bold
              columns(0).width = 40
              columns(1).width = 90
              columns(2).width = 50
             
              columns(3).width = 30
              columns(4).width = 35
              columns(5).width = 60
              columns(6).width = 60
              columns(8).width = 80
              columns(0).align = :left
              columns(1).align = :left
              columns(2).align = :left
              columns(4).align = :left
              end
   
           pdf.text "\n", size: 6  
           pdf.text "\n", size: 6  
           end   
        
        send_data pdf.render, filename: 'transfer_sheet.pdf', type: 'application/pdf', :disposition => 'inline'
     end
   end
        
   end
  
  
  
  def download_transfers_sheet_pdf_oo
      @start_date = Date.today.beginning_of_year # Current vacation calendar year
      @end_date = Date.today.end_of_year # Current vacation calendar year - end
     
      @transfers = Transfer.where(no_pick_up: true). where("arrival_time IS NOT NULL")
      @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
      @transfers_by_arrival_date_only = @transfers.group_by { |t| t.arrival_date_only }
 
    
      respond_to do |format|
        format.pdf do
         #DOCUMENT SETUP_START
        pdf = Prawn::Document.new()  
         @pdf.text ":: NETBALL AMERICA :: US Open"+"\n", size: 6
         @pdf.text "\n", size: 6  
         @pdf.text "Transfers Sheet: " + @start_date.to_date.strftime('%d %b, %Y') + " - " + @end_date.to_date.strftime('%d %b, %Y'), size: 14, style: :bold
         @pdf.text "Print Date: "+Date.today.to_s+"\n", size: 6
         @pdf.text "\n", size: 6  
         #DOCUMENT SETUP_END  
      
         #FOH_SUMMARY_START
                pdf.text "Front of House", size: 10, style: :bold 
        
                  foh_table_data = Array.new
                  foh_table_data << ["Name","Accrued Hours"]
                  @foh_staffhours.each do |staff, foh_hours|
       
                  foh_table_data << [Staff.find(staff).name, foh_hours.map { |h| h[:wk_accrued_hours] }.compact.sum.to_d.to_s]
               end   
                   pdf.table(foh_table_data) do 
                     self.width = 150
                     self.cell_style = { :inline_format => true, size: 6 } 
                      row(0).font_style = :bold
                     columns(0).width = 100
                     columns(1).width = 50
                     columns(0).align = :left
                     columns(1).align = :right
                     end
          
                  pdf.text "\n", size: 6  
                  pdf.text "\n", size: 6  
            
                  #KITCHEN_SUMMARY_START
                  pdf.text "Kitchen", size: 10, style: :bold 
        
                    table_data = Array.new
                    table_data << ["Name","Hours"]
                    @kit_staffhours.each do |staff, kit_hours|
       
                    table_data << [Staff.find(staff).name, kit_hours.map { |h| h[:wk_accrued_hours] }.compact.sum.to_s]
                 end   
                     pdf.table(table_data) do 
                       self.width = 150 
                       self.cell_style = { :inline_format => true, size: 6 } 
                        row(0).font_style = :bold
                       columns(0).width = 100
                       columns(1).width = 50
                       columns(0).align = :left
                       columns(1).align = :right
                      end
                   send_data pdf.render, filename: 'vacation_accruel.pdf', type: 'application/pdf', :disposition => 'inline'
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
      params.require(:transfer).permit(:first_name, :last_name, :role, :check_in, :check_out, :room_type, :hotel_reservation, :share_volunteer, :arrival_airline, :arrival_flight, :arrival_time, :departure_airline, :departure_flight, :departure_time, :no_pick_up, :notes, :phone, :hotel_name, :pick_up_grouping, :pickup_type, :pickup_note, :departure_grouping, :departure_type, :departure_note)
    end
end
