class IndividualMembersController < ApplicationController
  before_action :set_individual_member, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /individual_members
  def index
   
    if is_admin? || current_user.role=="teams_grants"
      @individual_members = IndividualMember.all.order(:first_name)
   else
     @individual_members = IndividualMember.where(user_id: current_user.id)
   end
  end

  # GET /individual_members/1
  def show
  end

  # GET /individual_members/new
  def new
    @individual_member = IndividualMember.new
  end

  # GET /individual_members/1/edit
  def edit
  end

  # POST /individual_members
  def create
    @individual_member = IndividualMember.new(individual_member_params)
    @individual_member.user_id =current_user.id
   
    if @individual_member.save
      redirect_to @individual_member, notice: "Individual member was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /individual_members/1
  def update
    if @individual_member.update(individual_member_params)
      redirect_to @individual_member, notice: "Individual member was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /individual_members/1
  def destroy
    @individual_member.destroy
    redirect_to pages_membership_landing_path, notice: "Individual member was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_individual_member
      @individual_member = IndividualMember.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def individual_member_params
      params.require(:individual_member).permit(:first_name, :last_name, :email, :phone, :address, :city, :state, :zip, :gender, :interested_in_coaching, :interested_in_umpiring, :interested_in_usa_team, :place_of_birth, :age_status, :engagement_status, :membership_type, :notes)
    end
end
