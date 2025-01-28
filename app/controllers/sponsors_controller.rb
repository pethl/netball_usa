class SponsorsController < ApplicationController
  before_action :set_sponsor, only: %i[ show edit update destroy ]
 # before_action :set_select_collections, only: [:edit, :update, :new, :create]
  load_and_authorize_resource


 

  # GET /sponsors
  def index

    @sponsors = Sponsor.all.ordered

    # Filter by city
    @sponsors = @sponsors.where('city ILIKE ?', "%#{params[:city]}%").ordered if params[:city].present?

    # Filter by state
    @sponsors = @sponsors.where(state: params[:state]).ordered if params[:state].present?

    # Add search by company_name
    @sponsors = @sponsors.where('company_name ILIKE ?', "%#{params[:company_name]}%") if params[:company_name].present?
    
     # Filter by expat_co
     @sponsors = @sponsors.where(expat_co: params[:expat_co]).ordered if params[:expat_co].present?

  end

  # GET /sponsors/1 
  def show
    @contacts = @sponsor.contacts.ordered
    if is_admin? 
      @opportunities = @sponsor.opportunities.ordered
    else
     @opportunities = @sponsor.opportunities.where(user_id: current_user.id)
    end
  end 

  # GET /sponsors/new
  def new
    @sponsor = Sponsor.new
   # @users = helpers.active_admin_users
  end

  # GET /sponsors/1/edit
  def edit
   # @users = helpers.active_admin_users
    @contacts = @sponsor.contacts.ordered
  end

  # POST /sponsors
  def create
    @sponsor = Sponsor.new(sponsor_params)

    if @sponsor.save
      redirect_to @sponsor, notice: "Sponsor was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sponsors/1
  def update
    if @sponsor.update(sponsor_params)
      redirect_to @sponsor, notice: "Sponsor was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /sponsors/1
  def destroy
    @sponsor.destroy
    redirect_to sponsors_url, notice: "Sponsor was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sponsor
      @sponsor = Sponsor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sponsor_params
      params.require(:sponsor).permit(:sponsor_category, :expat_co, :sponsor_type, :industry, :company_name, :status, :about, :city, :state, :location, :website, :key_contacts, :phone_numbers_emails, :opportunity_area, :pitch, :follow_up_actions, :notes, :user_id, :old_user_id)
    end
    
   # def set_select_collections
   #   @users = helpers.active_admin_users
   # end
end
