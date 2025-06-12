class ClubsController < ApplicationController
  before_action :set_club, only: %i[ show edit update destroy ]
  load_and_authorize_resource


  def index_admin
    @clubs = Club.all.ordered
  end 
  
  # GET /clubs
  def index
    if is_admin? 
      @clubs = Club.where(user_id: active_admin_users)
    elsif current_user.teams_grants?
      @clubs = Club.where(user_id: active_admin_users)
    else
     @club = Club.where(user_id: current_user.id).first
    end
  end

  def teams_list_index
    @clubs_for_report = Club.all
    @clubs_for_report = @clubs_for_report.order(us_state: :asc)
    @clubs_by_us_state = @clubs_for_report.group_by { |t| t.us_state }
    @regions = Region.all.order(region: :asc)
    @regions_by_region = @regions.group_by { |t| t.region }
 end

 def renew_membership
  club = Club.find(params[:id])
  response = params[:response]

  if response.in?(%w[yes no])
    renewed_years = (club.renewal_years || "").split(",").map(&:to_i)
    renewed_years << Date.today.year unless renewed_years.include?(Date.today.year)

    club.update(
      renewal_response: response,
      renewal_years: renewed_years.join(",")
    )

    if response == "yes"
      flash[:notice] = "🎉 Thanks for saying YES! Welcome to a brand new season with Netball America®!"
    else
      flash[:alert] = "Thanks for letting us know. Hope to see you back in the future!"
    end

    redirect_to pages_membership_landing_path
  else
    flash[:alert] = "Invalid choice."
    redirect_to pages_membership_landing_path
  end
end

  # GET /clubs/1
  def show
  end

  # GET /clubs/new
  def new
      @club = Club.new
      @club.netball_association_id = params[:netball_association_id] if params[:netball_association_id].present?
    end

  # GET /clubs/1/edit
  def edit
    if params[:context] == "show"
      render turbo_stream: turbo_stream.replace(
        "club-details-#{@club.id}",
        partial: "clubs/form",
        locals: { club: @club }
      )
    else
      render :edit # default full-page edit for other pages
    end
  end

  # POST /clubs
  def create
    Rails.logger.debug "🎯 PARAMS CONTEXT: #{params[:context].inspect}"
    Rails.logger.debug "🔍 Submitted netball_association_id: #{params[:netball_association_id]}"

    @club = Club.new(club_params)
    @club.creator = current_user
    @club.netball_association_id ||= params[:netball_association_id]

  
    if @club.save
      if params[:context] == "association"
        redirect_to netball_association_path(@club.netball_association), notice: "Club created and linked to this association."
      else
        respond_to do |format|
          format.html { redirect_to clubs_path, notice: "Club created." }
          format.turbo_stream
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clubs/1
  def update
    if @club.update(club_params)
      if params[:context] == "show"
        redirect_to netball_association_path(@club.netball_association), notice: "Club updated.", status: :see_other
      else
        redirect_to clubs_path, notice: "Club was successfully updated.", status: :see_other
      end
    else
      if params[:context] == "show"
        render turbo_stream: turbo_stream.replace(
          "club-details-#{@club.id}",
          partial: "clubs/form",
          locals: { club: @club }
        ), status: :unprocessable_entity
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end
  

  # DELETE /clubs/1
  def destroy
    @club.destroy
    redirect_to clubs_url, notice: "Club was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_club
      @club = Club.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def club_params
      params.require(:club).permit(:name, :city, :us_state, :membership_category, :email, :website, :facebook, :twitter, :instagram, :other_sm, :estimate_total_number_of_club_members, :estimate_total_active_members, :estimate_total_part_time_members, :netball_association_id)
    end

    def active_admin_users
      User.where(admin: true, role: 0).pluck(:id)
     end
end
