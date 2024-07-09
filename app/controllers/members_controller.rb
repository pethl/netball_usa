class MembersController < ApplicationController
  before_action :set_team
  before_action :set_member, only: [:edit, :update, :destroy, :show]
  
  # GET /members
  def index
    @members = Member.all.ordered
  end

  # GET /members/1
  def show
  end

  # GET /members/new
  def new
   # @member = Member.new
     @member = @na_team.members.build
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  def create
   @member = @na_team.members.build(member_params)

       if @member.save
         respond_to do |format|
                format.html { redirect_to team_path(@team), notice: "Member was successfully created." }
                format.turbo_stream { flash.now[:notice] = "Member was successfully created." }
              end 
            else
         render :new, status: :unprocessable_entity
       end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
         redirect_to na_team_path(@na_team), notice: "Member was successfully updated."
       else
         render :edit, status: :unprocessable_entity
       end
  end

  # DELETE /members/1
  def destroy
     @member.destroy
     respond_to do |format|
        format.html { redirect_to na_team_path(@na_team), notice: "Member was successfully deleted." }
        format.turbo_stream { flash.now[:notice] = "Member was successfully deleted." }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
#    def set_member
#      @member = Member.find(params[:id])
#    end
    
    def set_team
       @na_team = NaTeam.find(params[:na_team_id])
     end
     
     def set_member
        @member = @na_team.members.find(params[:id])
       end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:na_team_id, :first_name, :last_name, :email, :city, :state, :gender, :interested_in_coaching, :interested_in_umpiring, :interested_in_usa_team, :dob, :age_status, :member_engagement_status, :place_of_birth, :notes)
    end
end
