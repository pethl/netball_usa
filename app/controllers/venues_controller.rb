class VenuesController < ApplicationController
  before_action :set_venue, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /venues
  def index
    @venues = Venue.sorted_by_venue_name 
  end

  # GET /venues/1
  def show
  end

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
  end

  # POST /venues
  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      redirect_to @venue, notice: "Venue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /venues/1
  def update
    if @venue.update(venue_params)
      redirect_to @venue, notice: "Venue was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /venues/1
  def destroy
    @venue.destroy
    redirect_to venues_url, notice: "Venue was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def venue_params
      params.require(:venue).permit(:facility_type, :venue_name, :street, :city, :state, :zip, :website, :contact_name, :role, :phone, :email, :permit_application_link, :grant_information_link, :number_of_courts, :size_of_courts, :retractable_basketball_hoops, :space_from_courts_to_wall, :seating_available, :restaurant_onsite, :facilities_close_by, :locker_rooms_onsite, :pool, :hot_tub, :bed_types, :cost_per_hour, :cost_per_day, :cost_per_night, :notes)
    end
end
