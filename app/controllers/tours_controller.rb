class ToursController < ApplicationController
  before_action :set_tour, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /tours
  def index
    @tours = Tour.ordered_by_company
  end
 
  # GET /tours/1
  def show
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  def create
    @tour = Tour.new(tour_params)

    if @tour.save
      redirect_to @tour, notice: "Tour was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tours/1
  def update
    if @tour.update(tour_params)
      redirect_to @tour, notice: "Tour was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /tours/1
  def destroy
    @tour.destroy
    redirect_to tours_url, notice: "Tour was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tour_params
      params.require(:tour).permit(:company, :description, :location, :city, :us_state, :country, :website, :date_initially_connected, :date_pitch_to_na, :date_pitch_by_na, :pitch_to_na, :pitch_by_na, :follow_up_action, :tour_agreement, :accept_tour, :date_of_decision, :first_name_primary, :last_name_primary, :role_primary, :email_primary, :cell_primary, :work_phone_primary, :first_name_secondary, :last_name_secondary, :role_secondary, :email_secondary, :cell_secondary, :work_phone_secondary,  :first_name_third, :last_name_third, :role_third, :email_third, :cell_third, :work_phone_third )
    end
end
