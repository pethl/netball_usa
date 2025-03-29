class MediaController < ApplicationController
  before_action :set_medium, only: %i[ show edit update destroy ]
  #before_action :set_medium, except: [:index, :my_media, :new]


  def published
    @published_media = Medium.where.not(media_announcement_link: [nil, ""]).where.not(release_date: nil).order(release_date: :desc)
  end

  # GET /media
  def index
    @media = Medium.all.ordered

    @media = @media.where(media_type: params[:media_type]) if params[:media_type].present?
    @media = @media.where("company_name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?
    @media = @media.where(city: params[:city]) if params[:city].present?
    @media = @media.where(state: params[:state]) if params[:state].present?
    @media = @media.where(region_other: params[:region_other]) if params[:region_other].present?
    @media = @media.where(country: params[:country]) if params[:country].present?
  end

  def my_media
    @media = Medium.where(user_id: current_user.id).ordered # Filter by current user

    @media = @media.where(media_type: params[:media_type]) if params[:media_type].present?
    @media = @media.where("company_name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?
    @media = @media.where(city: params[:city]) if params[:city].present?
    @media = @media.where(state: params[:state]) if params[:state].present?
    @media = @media.where(region_other: params[:region_other]) if params[:region_other].present?
    @media = @media.where(country: params[:country]) if params[:country].present?
    render :index # Reuse the index view
  end

  # GET /media/1
  def show
  end

  # GET /media/new
  def new
    @medium = Medium.new
    @medium.old_user_id = current_user.id
    @users = helpers.active_admin_users
  end

  # GET /media/1/edit
  def edit
    @medium.old_user_id = current_user.id
    @users = helpers.active_admin_users
  end

  # POST /media
  def create
    @medium = Medium.new(medium_params)
    @medium.old_user_id = current_user.id

    if @medium.user_id.blank? 
      @medium.user_id =current_user.id
     end

    if @medium.save
      send_allocation_email(@medium)
      redirect_to @medium, notice: "Medium was successfully created."
    else
      @users = helpers.active_admin_users # 💥 Fix the nil @users problem
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /media/1
  def update
    if @medium.update(medium_params)
      send_allocation_email(@medium)
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
      params.require(:medium).permit(:media_type, :company_name, :company_website, :contact_name, :contact_email, :action_taken, :socials, :facebook, :twitter, :instagram, :region_other, :contact_position, :email, :phone, :city, :state, :country, :pitch, :notes, :user_id, :old_user_id, :event_calender_link, :calendar_login_details, :media_announcement_link, :release_date)
    end
 
    def send_allocation_email(medium)
      unless medium.user_id == medium.old_user_id
        MediumMailer.with(medium: medium).record_allocation_notification.deliver_later
      end
    
  end
end
