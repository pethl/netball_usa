class TeamsController < ApplicationController
  before_action :set_club
  before_action :set_team, only: [:show, :edit, :update, :destroy]

    def index
      @teams = Team.all.ordered
    end
  
    def show
    end
  
    def new
      @team = @club.teams.build
     end
  
    def create
      @team = @club.teams.build(team_params)
  
      if @team.save
        respond_to do |format|
            format.html { redirect_to teams_path(@team), notice: "Team was successfully created." }
            format.turbo_stream { flash.now[:notice] = "Team was successfully created." }
          end
        else
        render :new, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
      if @team.update(team_params)
        redirect_to club_path(@club), notice: "Team was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  
    def destroy
      @team.destroy
      respond_to do |format|
        format.html { redirect_to club_path(@club), notice: "Team was successfully destroyed." }
        format.turbo_stream { flash.now[:notice] = "Team was successfully deleted." }
      end
    end
   
    private
  
    def set_club
      @club = Club.find(params[:club_id]) 
    end

    def set_team
      @team = @club.teams.find(params[:id])
     end

    # Only allow a list of trusted parameters through.
    def team_params
      params.require(:team).permit(:name, :club_id, :user_id)
    end
    
    
end
