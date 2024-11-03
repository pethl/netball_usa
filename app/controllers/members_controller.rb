class MembersController < ApplicationController
  before_action :set_club, only: [:edit, :update, :destroy, :show, :new, :create]
  before_action :set_member, only: [:edit, :update, :destroy, :show]
  
  # GET /members
  def index
    @members = Member.all.order(last_name: :asc)
  end

  # GET /members/1
  def show
  end

  # GET /members/new
  def new
   # @member = Member.new
     @member = @club.members.build
  end

  # GET /members/1/edit
  def edit
    @teams = Team.where(club_id: @club)
  end

  # POST /members
  def create
   @member = @club.members.build(member_params)

       if @member.save
         respond_to do |format|
                format.html { redirect_to member_path(@member), notice: "Record successfully created." }
                format.turbo_stream { flash.now[:notice] = "Member was successfully created." }
              end 
            else
         render :new, status: :unprocessable_entity
       end
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
         redirect_to club_path(@club), notice: "Member was successfully updated."
       else
         render :edit, status: :unprocessable_entity
       end
  end

  # DELETE /members/1
  def destroy
     @member.destroy
     respond_to do |format|
        format.html { redirect_to club_path(@club), notice: "Member was successfully deleted." }
        format.turbo_stream { flash.now[:notice] = "Member was successfully deleted." }
      end
  end
 
  private
    # Use callbacks to share common setup or constraints between actions.
#    def set_member
#      @member = Member.find(params[:id])
#    end
    
    def set_club
       @club = Club.find(params[:club_id])
    end
      
    def set_member
       @member = @club.members.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:na_team_id, :club_id, :team_id, :membership_type, :first_name, :last_name, :email, :phone,  :address, :city, :state, :zip,  :gender, :interested_in_coaching, :interested_in_umpiring, :interested_in_usa_team, :dob, :age_status, :engagement_status, :place_of_birth, :notes)
    end
end
