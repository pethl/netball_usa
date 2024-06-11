class GrantsController < ApplicationController
  before_action :set_grant, only: %i[ show edit update destroy ]
  

  # GET /grants
  def index
    
    if is_admin? 
       @grants = Grant.all
    else
       @grants = Grant.where(user_id: current_user.id)
    end
   
  end

  # GET /grants/1
  def show
    
  end

  # GET /grants/new
  def new
   
    @grant = Grant.new
  end

  # GET /grants/1/edit
  def edit
   
  end

  # POST /grants
  def create
    
    @grant = Grant.new(grant_params)
   
    if @grant.user_id.blank? 
      @grant.user_id =current_user.id
    end

    if @grant.save
      redirect_to @grant, notice: "Grant was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grants/1
  def update
   
    if @grant.update(grant_params)
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
      params.require(:grant).permit(:name, :apply, :amount, :location, :state, :due_date, :timezone, :purpose, :grant_link, :notes, :status, :date_submitted, :program, :application_link, :login, :user_id, :old_user_id, :action_by)
    end

end
