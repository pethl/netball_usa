class MemberKeyRolesController < ApplicationController
  before_action :set_na_team
  before_action :set_member_key_role, only: %i[ show edit update destroy ]


  # GET /member_key_roles/1
  def show
  end

  # GET /member_key_roles/new
  def new
    teams_owned_by_user = NaTeam.where(user_id: current_user.id)
    teams_owned_by_user = teams_owned_by_user.pluck(:id) 
    @members_belonging_to_administrator = Member.where(na_team_id: teams_owned_by_user)
    @members_belonging_to_administrator = @members_belonging_to_administrator.order(first_name: :asc)
   # @member_key_role = MemberKeyRole.new
    @member_key_role = @na_team.member_key_roles.build
  end

  # GET /member_key_roles/1/edit
  def edit
    teams_owned_by_user = NaTeam.where(user_id: current_user.id)
    teams_owned_by_user = teams_owned_by_user.pluck(:id) 
    @members_belonging_to_administrator = Member.where(na_team_id: teams_owned_by_user)
    @members_belonging_to_administrator = @members_belonging_to_administrator.order(first_name: :asc)
  end

  # POST /member_key_roles
  def create
    teams_owned_by_user = NaTeam.where(user_id: current_user.id)
    teams_owned_by_user = teams_owned_by_user.pluck(:id) 
    @members_belonging_to_administrator = Member.where(na_team_id: teams_owned_by_user)
    @members_belonging_to_administrator = @members_belonging_to_administrator.order(first_name: :asc)
    @member_key_role = @na_team.member_key_roles.build(member_key_role_params)
   # @member_key_role = MemberKeyRole.new(member_key_role_params)
 

    if @member_key_role.save
      respond_to do |format|
         format.html { redirect_to @na_team, notice: "Key role  was successfully created." }
         format.turbo_stream { flash.now[:notice] = "Key role was successfully created." }
       end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /member_key_roles/1
  def update
    teams_owned_by_user = NaTeam.where(user_id: current_user.id)
    teams_owned_by_user = teams_owned_by_user.pluck(:id) 
    @members_belonging_to_administrator = Member.where(na_team_id: teams_owned_by_user)
    @members_belonging_to_administrator = @members_belonging_to_administrator.order(first_name: :asc)

    if @member_key_role.update(member_key_role_params)
      redirect_to na_team_path(@na_team), notice: "Member key role was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /member_key_roles/1
  def destroy
    @member_key_role.destroy
    respond_to do |format|
       format.html { redirect_to team_path(@team), notice: "Member key role was successfully deleted." }
       format.turbo_stream { flash.now[:notice] = "Member key role was successfully deleted." }
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_na_team
       @na_team = NaTeam.find(params[:na_team_id])
     end
     
    
    def set_member_key_role
      @member_key_role = @na_team.member_key_roles.find(params[:id])
  
    end

    # Only allow a list of trusted parameters through.
    def member_key_role_params
      params.require(:member_key_role).permit(:na_team_id, :member_id, :key_role)
    end

    # def members_belonging_to_administrator
    #   teams_owned_by_user = NaTeam.where(user_id: @current_user.id)
    #   teams_owned_by_user = teams_owned_by_user.pluck(:id) 
    #   @members_belonging_to_administrator = Member.where(na_team_id: teams_owned_by_user)
    #   @members_belonging_to_administrator = @members_belonging_to_administrator.order(first_name: :asc)
    #  end
end
