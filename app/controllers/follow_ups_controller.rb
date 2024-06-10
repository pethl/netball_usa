class FollowUpsController < ApplicationController
  before_action :set_follow_up, only: %i[ show edit update destroy ]

  # GET /follow_ups
  def index
    authorize! :read, @follow_ups
    if is_admin? 
       @follow_ups = FollowUp.all
       @follow_ups = @follow_ups.order(created_at: :desc)
    else
        @follow_ups = FollowUp.where(user_id: current_user.id)
        @follow_ups = @follow_ups.order(created_at: :desc)
      end
  end

  # GET /follow_ups/1
  def show
  end

  # GET /follow_ups/new
  def new
    @follow_up = FollowUp.new
    @netball_educators = NetballEducator.all
    @netball_educators = @netball_educators.order(last_name: :asc)
    @events = Event.all
    @events = @events.order(date: :asc)
  end

  # GET /follow_ups/1/edit
  def edit
    @netball_educators = NetballEducator.all
    @netball_educators = @netball_educators.order(last_name: :asc)
    @events = Event.all
    @events = @events.order(date: :asc)
  end

  # POST /follow_ups
  def create
    @follow_up = FollowUp.new(follow_up_params)
    @events = Event.all
    @netball_educators = NetballEducator.all
    if @follow_up.save
      redirect_to @follow_up, notice: "Follow up was successfully created."
    else
      @events = Event.all
      @events = @events.order(date: :asc)
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /follow_ups/1
  def update
    if @follow_up.update(follow_up_params)
      redirect_to @follow_up, notice: "Follow up was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /follow_ups/1
  def destroy
    @follow_up.destroy
    redirect_to follow_ups_url, notice: "Follow up was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_follow_up
      @follow_up = FollowUp.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def follow_up_params
      params.require(:follow_up).permit(:lead_type, :status, :action_items, :sale_amount, :add_to_mailing_list, :event_id, :netball_educator_id, :user_id)
    end
end
