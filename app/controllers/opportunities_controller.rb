class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: %i[ show edit update destroy ]
  before_action :set_sponsor

  # GET /opportunities
  def index
    @opportunities = Opportunity.all
  end

  # GET /opportunities/1
  def show
  end

  # GET /opportunities/new
  def new
    #@opportunity = Opportunity.new
    @opportunity = @sponsor.opportunities.build
    @users = User.all
  end

  # GET /opportunities/1/edit
  def edit
    @users = User.all
    @contacts = @sponsor.contacts.ordered
  end

  # POST /opportunities
  def create  
    @opportunity = @sponsor.opportunities.build(opportunity_params)


    if @opportunity.save
     
      redirect_to sponsor_path(@sponsor), notice: "Opportunity was successfully created."
 
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /opportunities/1
  def update
    if @opportunity.update(opportunity_params)
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
      params.require(:opportunity).permit(:sponsor_id, :contact_id, :status, :user_id, :old_user_id, :opportunity_type, :website, :area, :pitch, :follow_up_actions, :notes)
    end
end
