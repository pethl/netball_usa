class MemberKeyRolesController < ApplicationController
  before_action :set_team
  before_action :set_member_key_role, only: %i[ show edit update destroy ]


  # GET /member_key_roles/1
  def show
  end

  # GET /member_key_roles/new
  def new
   # @member_key_role = MemberKeyRole.new
    @member_key_role = @team.member_key_roles.build
  end

  # GET /member_key_roles/1/edit
  def edit
  end

  # POST /member_key_roles
  def create
    @member_key_role = @team.member_key_roles.build(member_key_role_params)
   # @member_key_role = MemberKeyRole.new(member_key_role_params)

    if @member_key_role.save
      respond_to do |format|
         format.html { redirect_to @team, notice: "Key role  was successfully created." }
         format.turbo_stream { flash.now[:notice] = "Key role was successfully created." }
       end
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /member_key_roles/1
  def update
    if @member_key_role.update(member_key_role_params)
      redirect_to team_path(@team), notice: "Member key role was successfully updated."
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
    def set_team
       @team = Team.find(params[:team_id])
     end
     
    
    def set_member_key_role
      @member_key_role = MemberKeyRole.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_key_role_params
      params.require(:member_key_role).permit(:team_id, :na_member_id, :key_role)
    end
end
