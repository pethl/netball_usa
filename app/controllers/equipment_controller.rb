class EquipmentController < ApplicationController
  before_action :set_equipment, only: %i[ show edit update destroy ]
  
  # GET /equipment
  def index
    authorize! :read, @equipments
   # @equipment = Equipment.all
    @equipment = NetballEducator.joins(:equipment)
    @equipment  =  @equipment.order(state: :ASC, city: :ASC ) 
   
  end

  # GET /equipment/1
  def show
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
    @netball_educators = NetballEducator.all
    @netball_educators = @netball_educators.order(last_name: :asc)
  end

  # GET /equipment/1/edit
  def edit
    @netball_educators = NetballEducator.all
    @netball_educators = @netball_educators.order(last_name: :asc)
    
  end

  # POST /equipment
  def create
    @equipment = Equipment.new(equipment_params)

    if @equipment.save
      redirect_to @equipment, notice: "Equipment was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /equipment/1
  def update
    if @equipment.update(equipment_params)
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
      params.require(:equipment).permit(:items_purchased, :purchase_amount, :sale_date, :netball_educator_id)
    end
end
