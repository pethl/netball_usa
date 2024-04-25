class MembersController < ApplicationController
  #before_action :set_member, only: %i[ show edit update destroy ]
  before_action :set_team
  before_action :set_member, only: [:edit, :update, :destroy]
  
  # GET /members
  def index
    @members = Member.all
  end

  # GET /members/1
  def show
  end

  # GET /members/new
  def new
   # @member = Member.new
     @member = @team.members.build
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  def create
   @member = @team.members.build(member_params)

       if @member.save
         respond_to do |format|
                format.html { redirect_to team_path(@quote), notice: "Member was successfully created." }
                format.turbo_stream { flash.now[:notice] = "Member was successfully created." }
              end 
            else
         render :new, status: :unprocessable_entity
       end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
         redirect_to team_path(@team), notice: "Member was successfully updated."
       else
         render :edit, status: :unprocessable_entity
       end
  end

  # DELETE /members/1
  def destroy
     @member.destroy
       redirect_to team_path(@team), notice: "Member was successfully destroyed."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
#    def set_member
#      @member = Member.find(params[:id])
#    end
    
    def set_team
       @team = Team.find(params[:team_id])
     end
     
     def set_member
         @member = @team.members.find(params[:id])
       end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:team_id, :first_name, :last_name, :email, :city, :state, :gender, :interested_in_coaching, :interested_in_umpiring, :interested_in_usa_team, :dob, :place_of_birth, :notes)
    end
end
