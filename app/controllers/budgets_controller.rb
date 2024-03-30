class BudgetsController < ApplicationController
  before_action :set_event_collections, only: %i[ new show edit update ]
  before_action :set_budget, only: %i[ show edit update destroy ]
  
  # GET /budgets
  def index
    @budgets = Budget.all
  end

  # GET /budgets/1
  def show
  end

  # GET /budgets/new
  def new
    @budget = Budget.new
   
  end

  # GET /budgets/1/edit
  def edit
   end

  # POST /budgets
  def create
    @budget = Budget.new(budget_params)

    if @budget.save
      redirect_to @budget, notice: "Budget was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /budgets/1
  def update
    if @budget.update(budget_params)
      redirect_to @budget, notice: "Budget was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /budgets/1
  def destroy
    @budget.destroy
    redirect_to budgets_url, notice: "Budget was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id])
    end
    
    # Get event list for drop down.
    def set_event_collections
      @events= Event.all
    end

    # Only allow a list of trusted parameters through.
    def budget_params
      params.require(:budget).permit(:event_id, :flight, :flight_notes, :hotel, :hotel_notes, :transport, :transport_notes, :shipping, :shipping_notes, :booth, :booth_notes, :carpet, :carpet_notes, :banners, :banner_notes, :giveaways, :giveaway_notes)
    end
end
