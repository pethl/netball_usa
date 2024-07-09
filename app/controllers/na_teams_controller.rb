class NaTeamsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_na_team, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /na_teams 
  def index_admin
    @na_teams = NaTeam.all
  end
  
  # GET /na_teams
  def index
    @na_teams = NaTeam.where(user_id: current_user.id)
    @na_teams=@na_teams.ordered
  end

   def teams_list_index
      @na_teams = NaTeam.all
      @na_teams = @na_teams.order(state: :asc)
      @teams_by_state = @na_teams.group_by { |t| t.state }
      @regions = Region.all.order(region: :asc)
      @regions_by_region = @regions.group_by { |t| t.region }
   end

  # GET /na_teams/1
  def show
  end

  # GET /na_teams/new
  def new
    @na_team = NaTeam.new
    @events = Event.where(event_type: "US Open")
  end

  # GET /na_teams/1/edit
  def edit
  end

  # POST /na_teams
  def create
    @na_team = NaTeam.new(na_team_params)
    @na_team.user_id = current_user.id

    if @na_team.save
      respond_to do |format|
        format.html { redirect_to na_teams_path, notice: "Team was successfully created." }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /na_teams/1
  def update
    if @na_team.update(na_team_params)
      redirect_to na_teams_path, notice: "Team was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
    
  end

  # DELETE /na_teams/1
  def destroy
    @na_team.destroy
    respond_to do |format|
      format.html { redirect_to na_teams_path, notice: "Team was successfully destroyed." }
      format.turbo_stream 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_na_team
      @na_team = NaTeam.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def na_team_params
      params.require(:na_team).permit(:name, :city, :state, :user_id, :website, :facebook, :twitter, :instagram, :other_sm)
    end
end

