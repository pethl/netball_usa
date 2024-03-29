class TransfersController < ApplicationController
  before_action :set_transfer, only: %i[ show edit update destroy ]

  # GET /transfers
  def index
    @transfers = Transfer.all
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
      params.require(:transfer).permit(:first_name, :last_name, :role, :check_in, :check_out, :room_type, :hotel_reservation, :share_volunteer, :arrival_airline, :arrival_flight, :arrival_time, :departure_airline, :departure_flight, :departure_time, :no_pick_up, :notes)
    end
end
