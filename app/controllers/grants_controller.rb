class GrantsController < ApplicationController
  before_action :set_grant, only: %i[ show edit update destroy ]
  load_and_authorize_resource
  

  # GET /grants
  def index
    
    if is_admin? 
       @grants = Grant.all.order(:name)
    else
       @grants = Grant.where(user_id: current_user.id).order(:name)
    end
   
  end

  # GET /grants/1
  def show
    
  end

  # GET /grants/new
  def new
    @grant = Grant.new
    @users = helpers.active_admin_users
  end

  # GET /grants/1/edit
  def edit
    @users = helpers.active_admin_users
  end

  # POST /grants
  def create
    
    @grant = Grant.new(grant_params)
    @grant.old_user_id =current_user.id
    if @grant.user_id.blank? 
      @grant.user_id =current_user.id
     end

    if @grant.save
       send_allocation_email(@grant)
      redirect_to @grant, notice: "Grant was successfully created."
    else
      @users = helpers.active_admin_users
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grants/1
  def update
   
    if @grant.update(grant_params)
      send_allocation_email(@grant)
      redirect_to @grant, notice: "Grant was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.destroy
    redirect_to grants_url, notice: "Grant was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant
      @grant = Grant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grant_params
      params.require(:grant).permit(:name, :apply, :amount, :location, :state, :grant_type, :inkind_description, :due_date, :timezone, :purpose, :grant_link, :notes, :status, :date_submitted, :program, :application_link, :login, :notification_date, :user_id, :old_user_id, :action_by)
    end

  def send_allocation_email(grant)
    unless grant.user_id == grant.old_user_id
      GrantMailer.with(grant: grant).record_allocation_notification.deliver_later
    end
  end

end
