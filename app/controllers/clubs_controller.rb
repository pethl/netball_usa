class ClubsController < ApplicationController
  before_action :set_club, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /clubs
  def index
    if is_admin?
      @clubs = Club.where(user_id: active_admin_users)
    else
     @club = Club.where(user_id: current_user.id).first
    end
  end

  def index_admin
    @clubs = Club.all.ordered
  end

  def teams_list_index
    @clubs_for_report = Club.all
    @clubs_for_report = @clubs_for_report.order(us_state: :asc)
    @clubs_by_us_state = @clubs_for_report.group_by { |t| t.us_state }
    @regions = Region.all.order(region: :asc)
    @regions_by_region = @regions.group_by { |t| t.region }
 end

  # GET /clubs/1
  def show
  end

  # GET /clubs/new
  def new
    @club = Club.new
  end

  # GET /clubs/1/edit
  def edit
  end

  # POST /clubs
  def create
    @club = Club.new(club_params)
    @club.user_id = current_user.id

    if @club.save
      respond_to do |format|
        format.html { redirect_to clubs_path, notice: "Club was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /clubs/1
  def update
    if @club.update(club_params)
      redirect_to clubs_path, notice: "Club was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
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
      params.require(:club).permit(:name, :city, :us_state, :membership_category, :website, :facebook, :twitter, :instagram, :other_sm, :estimate_total_number_of_club_members, :estimate_total_active_members, :estimate_total_part_time_members)
    end

    def active_admin_users
      User.where(admin: true, role: 0).pluck(:id)
     end
end
