class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :require_permission, only: [:edit, :update, :destroy]

  # GET /teams
  def index
     if current_user&.admin? || current_user&.office?
         @teams = Team.ordered
        else
      @teams = current_user.teams
    end
  end
  
  def teams_list_index
      @teams = Team.all
      @teams = @teams.order(state: :asc)
      @teams_by_state = @teams.group_by { |t| t.state }
      @teams_by_state = @teams.group_by { |t| t.state }
      @regions = Region.all.order(region: :asc)
      @regions_by_region = @regions.group_by { |t| t.region }
 end
  
  # GET /teams/1
  def show
     @members = @team.members.ordered
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    @team.user_id =current_user.id

    if @team.save
      respond_to do |format|
           format.html { redirect_to quotes_path, notice: "Team was successfully created." }
           format.turbo_stream
         end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: "Team was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    respond_to do |format|
        format.html { redirect_to teams_path, notice: "Team was successfully destroyed." }
        format.turbo_stream
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :user_id, :city, :state, :website, :facebook, :twitter, :instagram, :other_sm)
    end
    
    def require_permission
      if Team.find(params[:id]).creator != current_user
        redirect_to teams_path, flash: { error: "You do not have permission to do that." }
      end
    end
end
