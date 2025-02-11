class MediaController < ApplicationController
  before_action :set_medium, only: %i[ show edit update destroy ]

  # GET /media
  def index
    @media = Medium.all.ordered

    @media = @media.where(media_type: params[:media_type]) if params[:media_type].present?
    @media = @media.where("company_name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?
    @media = @media.where(city: params[:city]) if params[:city].present?
    @media = @media.where(state: params[:state]) if params[:state].present?
    @media = @media.where(country: params[:country]) if params[:country].present?
   
  end

  # GET /media/1
  def show
  end

  # GET /media/new
  def new
    @medium = Medium.new
  end

  # GET /media/1/edit
  def edit
  end

  # POST /media
  def create
    @medium = Medium.new(medium_params)

    if @medium.save
      redirect_to @medium, notice: "Medium was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /media/1
  def update
    if @medium.update(medium_params)
      redirect_to @medium, notice: "Medium was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /media/1
  def destroy
    @medium.destroy
    redirect_to media_url, notice: "Medium was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medium
      @medium = Medium.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def medium_params
      params.require(:medium).permit(:media_type, :company_name, :contact_name, :contact_position, :email, :phone, :city, :state, :country, :pitch, :media_announcement_link)
    end
end
