class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: %i[ show edit update destroy ]
  #before_action :set_sponsor, only: %i[ new create show edit update destroy ]
  before_action :set_sponsor, except: [:index, :closed, :my_index]
  load_and_authorize_resource

  # GET /opportunities
  def index
    @opportunities = Opportunity.joins(:sponsor).where.not(status: "Completed")
                                .order("sponsors.company_name ASC") 
  end

  def closed
    @opportunities = Opportunity.joins(:sponsor)
                                 .where(status: "Completed")
                                 .order("sponsors.company_name ASC")
    render :index
  end

  # Custom action to show opportunities belonging to the current user
  def my_index
    @opportunities = Opportunity.where(user_id: current_user.id).where.not(status: "Completed").includes(:sponsor).order('sponsors.company_name')
    render :index # Reuse the same index view to avoid code duplication
  end

  # GET /opportunities/1
  def show
   
  end

  # GET /opportunities/new
  def new
    #@opportunity = Opportunity.new
   # @contacts = @sponsor&.contacts&.order(:name) || []
    @contacts = @sponsor.contacts.ordered
    @opportunity = @sponsor.opportunities.build
   # @opportunity.user_id = current_user.id
    @opportunity.old_user_id = current_user.id
    @users = helpers.active_admin_users
  end

  # GET /opportunities/1/edit
  def edit
    @users = helpers.active_admin_users
    @contacts = @sponsor.contacts.ordered
  end

  # POST /opportunities
  def create  
    @opportunity = @sponsor.opportunities.build(opportunity_params) 
    @opportunity.old_user_id = current_user.id

    if @opportunity.user_id.blank? 
      @opportunity.user_id =current_user.id
     end
   
    if @opportunity.save
      send_allocation_email(@opportunity)
      redirect_to sponsor_path(@sponsor), notice: "Opportunity was successfully created."
 
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /opportunities/1
  def update
    if @opportunity.update(opportunity_params)
      send_allocation_email(@opportunity)
      redirect_to sponsor_path(@sponsor), notice: "Opportunity was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /opportunities/1
  def destroy
    @opportunity.destroy
    redirect_to sponsor_path(@sponsor), notice: "Opportunity was successfully destroyed.", status: :see_other
  end

  private
  def set_sponsor
    @sponsor = Sponsor.find(params[:sponsor_id])
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_opportunity
      @opportunity = Opportunity.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def opportunity_params
      params.require(:opportunity).permit(:sponsor_id, :contact_id, :status, :in_progress_status, :user_id, :old_user_id, :opportunity_type, :website, :area, :pitch, :follow_up_actions, :notes, :outcome, :outcome_date, :outcome_received, :date_submitted)
    end

    def send_allocation_email(opportunity)
        unless opportunity.user_id == opportunity.old_user_id
          OpportunityMailer.with(opportunity: opportunity).record_allocation_notification.deliver_later
        end
      
    end
end
