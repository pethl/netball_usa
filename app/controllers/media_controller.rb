class MediaController < ApplicationController
  before_action :set_medium, only: %i[ show edit update destroy ]
  before_action :set_users, only: %i[ new edit create update ]

  def published
    @press_releases = PressRelease
      .includes(:medium)
      .where.not(media_announcement_link: [nil, ""])
      .where.not(release_date: nil)
      .order(release_date: :desc)
  end
  

  def index
    @media = Medium.ordered
  
    @media = @media.where(media_type: params[:media_type]) if params[:media_type].present?
    @media = @media.where("company_name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?
    @media = @media.where("city ILIKE ?", "%#{params[:city]}%") if params[:city].present?
    @media = @media.where("state ILIKE ?", "%#{params[:state]}%") if params[:state].present?
    @media = @media.where("region_other ILIKE ?", "%#{params[:region_other]}%") if params[:region_other].present?
    @media = @media.where("country ILIKE ?", "%#{params[:country]}%") if params[:country].present?
  end

  def my_media
    @media = Medium.where(user_id: current_user.id).ordered

    @media = @media.where(media_type: params[:media_type]) if params[:media_type].present?
    @media = @media.where("company_name ILIKE ?", "%#{params[:company_name]}%") if params[:company_name].present?
    @media = @media.where(city: params[:city]) if params[:city].present?
    @media = @media.where(state: params[:state]) if params[:state].present?
    @media = @media.where(region_other: params[:region_other]) if params[:region_other].present?
    @media = @media.where(country: params[:country]) if params[:country].present?
    render :index
  end

  def show
  end

  def new
    @medium = Medium.new
    @medium.press_releases.build if @medium.press_releases.empty?
    @medium.old_user_id = current_user.id
  end

  def edit
    @medium.press_releases.build if @medium.press_releases.empty?
    @medium.old_user_id = current_user.id
  end

  def create
    @medium = Medium.new(medium_params)
    @medium.old_user_id = current_user.id
    @medium.user_id = current_user.id if @medium.user_id.blank?

    if @medium.save
      send_allocation_email(@medium)
      redirect_to @medium, notice: "Medium was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @medium.update(medium_params)
      send_allocation_email(@medium)
      redirect_to @medium, notice: "Medium was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @medium.destroy
    redirect_to media_url, notice: "Medium was successfully destroyed.", status: :see_other
  end

  private

    def set_medium
      @medium = Medium.find(params[:id])
    end

    def set_users
      @users = helpers.active_admin_users
    end

    def medium_params
      params.require(:medium).permit(
        :media_type, :company_name, :company_website, :contact_name, :contact_email,
        :action_taken, :socials, :facebook, :twitter, :instagram, :region_other,
        :contact_position, :email, :phone, :city, :state, :country, :pitch, :notes,
        :user_id, :old_user_id, :event_calender_link, :calendar_login_details,
        :media_announcement_link, :release_date,
        press_releases_attributes: [
          :id, :media_announcement_link, :release_date, :title, :content, :_destroy
        ]
      )
    end

    def send_allocation_email(medium)
      unless medium.user_id == medium.old_user_id
        MediumMailer.with(medium: medium).record_allocation_notification.deliver_later
      end
    end
end
