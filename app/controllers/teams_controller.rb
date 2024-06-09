class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]

    def index
      @teams = Team.all
    end
  
    def show
    end
  
    def new
      @team = Team.new
    end
  
    def create
      @team = Team.new(team_params)
  
      if @team.save
        respond_to do |format|
            format.html { redirect_to teams_path, notice: "Team was successfully created." }
            format.turbo_stream
          end
        else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @team.update(team_params)
        redirect_to teams_path, notice: "Team was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @team.destroy
      respond_to do |format|
        format.html { redirect_to teams_path, notice: "Team was successfully destroyed." }
        format.turbo_stream
      end
    end
  
    private
  
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
