class NetballAcademiesController < ApplicationController
  before_action :set_netball_academy, only: %i[ show edit update destroy ]

  # GET /netball_academies
  def index
    @netball_academies = NetballAcademy.ordered
  
    # Search filters
    if params[:city].present?
      @netball_academies = @netball_academies.where("city ILIKE ?", "%#{params[:city]}%")
    end
  
    if params[:us_state].present?
      @netball_academies = @netball_academies.where(us_state: params[:us_state])
    end
  
    if params[:q].present?
      q = "%#{params[:q]}%"
      @netball_academies = @netball_academies.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?", q, q, q)
    end
  
    # If no search, apply tab filter
    unless search_active?
      if params[:filter] == "inactive"
        @netball_academies = @netball_academies.where(status: "Inactive")
      else
        @netball_academies = @netball_academies.where(status: "Active")
      end
    end
  end

  # GET /netball_academies/1
  def show
  end

  # GET /netball_academies/new
  def new
    @netball_academy = NetballAcademy.new
  end

  # GET /netball_academies/1/edit
  def edit
  end

  # POST /netball_academies
  def create
    @netball_academy = NetballAcademy.new(netball_academy_params)

    if @netball_academy.save
      redirect_to @netball_academy, notice: "Netball academy was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /netball_academies/1
  def update
    if @netball_academy.update(netball_academy_params)
      redirect_to @netball_academy, notice: "Netball academy was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /netball_academies/1
  def destroy
    @netball_academy.destroy!
    redirect_to netball_academies_url, notice: "Netball academy was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_netball_academy
      @netball_academy = NetballAcademy.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def netball_academy_params
      params.require(:netball_academy).permit(:first_name, :last_name, :email, :city, :us_state, :country, :club_id, :other_club_name, :status, :signed_up, :purchase_date, :subscribed_plans, :amount, :training_completed_date, :notes)
    end

    def search_active?
      params[:q].present? || params[:city].present? || params[:us_state].present?
    end
end
