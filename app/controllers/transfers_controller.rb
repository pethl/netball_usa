class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy ]
  skip_before_action :authenticate_user!, only:[:show, :create, :edit, :update, :index]

  # GET /transfers
  def index
    @transfers = Transfer.all
  end

  def index_inbound_pickup
    @no_transfers = Transfer.where(no_pick_up: true)
    @transfers = Transfer.where(no_pick_up: false)
    @transfers = @transfers.order(arrival_time: :asc).order(arrival_airline: :asc)
    @transfers_by_grouping = @transfers.group_by { |t| t.pick_up_grouping }
  end
  
  def index_outbound_pickup
    @transfers = Transfer.all.order(departure_time: :asc).order(arrival_airline: :asc)
    @transfers_by_grouping = @transfers.group_by { |t| t.departure_grouping }
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
