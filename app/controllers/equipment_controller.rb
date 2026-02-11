class EquipmentController < ApplicationController
  before_action :set_equipment, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  # GET /equipment
  def index
    @status = params[:status] || "Sale"
  
    @equipment =
      case @status
      when "Quote"
        Equipment
          .where(status: "Quote")
          .left_joins(:netball_educator)
          .order(created_at: :desc)
      else
        Equipment
          .where(status: "Sale")
          .joins(:netball_educator)
          .order(sale_date: :desc)
      end
  end
  

  # GET /equipment/1
  def show
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new(status: params[:status])
  
    # Preassign Netball Educator if coming from a link
    @equipment.netball_educator_id = params[:netball_educator_id] if params[:netball_educator_id].present?
  
    # Load all educators for the dropdown, ordered nicely
    @netball_educators = NetballEducator.order(:last_name)
  end
  

  # GET /equipment/1/edit
  def edit
    @netball_educators = NetballEducator.all
    @netball_educators = @netball_educators.order(last_name: :asc)
    
  end

  # POST /equipment
  def create
    @equipment = Equipment.new(equipment_params) # Load all educators for the dropdown, ordered nicely
    @netball_educators = NetballEducator.order(:last_name)

    if @equipment.save
      redirect_to @equipment, notice: "Equipment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /equipment/1
  def update
    if @equipment.update(equipment_params)
       # Load all educators for the dropdown, ordered nicely
      @netball_educators = NetballEducator.order(:last_name)
      redirect_to @equipment, notice: "Equipment was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /equipment/1
  def destroy
    @equipment.destroy
    redirect_to equipment_index_url, notice: "Equipment was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def equipment_params
      params.require(:equipment).permit(:status, :items_purchased, :purchase_amount, :sale_date, :customer_name, :customer_email, :customer_address, :items_quoted, :quote_amount, :netball_educator_id)
    end
end
