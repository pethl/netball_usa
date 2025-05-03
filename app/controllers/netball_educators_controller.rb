class NetballEducatorsController < ApplicationController
  include Pagy::Backend

  before_action :set_netball_educator, only: [:show, :edit, :update, :destroy]
  ##before_action :authenticate_user!
  before_action :set_users, only: [:new, :create, :edit, :update]

  def index
    # used for the modal
    @events = Event.educational.gone# or  filtered events 

    # 🔥 Educator Access Control
    @netball_educators = NetballEducator.all

    # 🔥 Filters
    if params[:state].present?
      @netball_educators = @netball_educators.where(state: params[:state])
    end

    if params[:city].present?
      @netball_educators = @netball_educators.where("city ILIKE ?", "%#{params[:city]}%")
    end

    # Filter by created_at if a date is selected
    if params[:created_at].present?
    selected_date = Date.parse(params[:created_at]) # Parse the date from the form
    @netball_educators = @netball_educators.where("created_at >= ?", selected_date.beginning_of_day)
  end

    # 🔥 Ordering
   # @netball_educators = @netball_educators.order(created_at: :desc)
   @netball_educators = @netball_educators.order(created_at: :desc)


     # ✅ Preload event participants as a set of educator IDs (for fast lookup in view)
    @educator_ids_with_participants = EventParticipant.where(netball_educator_id: @netball_educators.pluck(:id)).distinct.pluck(:netball_educator_id).to_set


    respond_to do |format|
      format.html do
        @pagy, @netball_educators = pagy(@netball_educators)
      end
  
      format.xlsx do
        # No pagination — use full filtered list
      end
    end
  end


  def pe_directors
      @netball_educators = NetballEducator.all.where(level: "School/District Lead")
      @netball_educators = @netball_educators.order("created_at DESC, state ASC, city ASC")
     # ✅ Preload event participants as a set of educator IDs (for fast lookup in view)
     @educator_ids_with_participants = EventParticipant.where(netball_educator_id: @netball_educators.pluck(:id)).distinct.pluck(:netball_educator_id).to_set


  end

  def my_educators
    @netball_educators = NetballEducator.where(user_id: current_user.id)
    @netball_educators = @netball_educators.order("created_at DESC, state ASC, city ASC")
      # ✅ Preload event participants as a set of educator IDs (for fast lookup in view)
      @educator_ids_with_participants = EventParticipant.where(netball_educator_id: @netball_educators.pluck(:id)).distinct.pluck(:netball_educator_id).to_set

  end

  def search
    if params[:search].present?
      query = params[:search]
      @netball_educators = NetballEducator.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%").order(:first_name)
    else
      @netball_educators = []
    end
  end

  def trainers_etc
    @active_trainers = Person
      .where(role: ["Trainer", "Ambassador"], status: "Active")
      .order(:educator_role, :last_name)
  
    @inactive_trainers = Person
      .where(role: ["Trainer", "Ambassador"], status: "Inactive")
      .order(:educator_role, :last_name)
  end

  def heat_map
    authorize! :heat_map, NetballEducator
  
    raw_counts = NetballEducator.group(:state).count
    # Rails.logger.info "RAW STATE COUNTS: #{raw_counts.inspect}"
  
    @educator_state_counts = raw_counts.each_with_object({}) do |(state, count), hash|
      next if state.blank?
  
      normalized =
        if US_STATE_ABBREVIATIONS.key?(state)
          US_STATE_ABBREVIATIONS[state]
        else
          state.to_s.strip.upcase
        end
  
      # Only include valid USPS codes
      next unless normalized.length == 2 && US_STATE_ABBREVIATIONS.value?(normalized)
  
      hash[normalized] ||= 0
      hash[normalized] += count
    end
  
    # Rails.logger.info "FILTERED EDUCATOR STATE COUNTS: #{@educator_state_counts.inspect}"
  end
  

  def show
  end

  def new
    @netball_educator = NetballEducator.new
  end

  def edit
  end

  def create
    @netball_educator = NetballEducator.new(netball_educator_params)

    if @netball_educator.save
      redirect_to @netball_educator, notice: 'Educator was successfully created.'
    else
      render :new
    end
  end

  def update
    if @netball_educator.update(netball_educator_params)
      redirect_to @netball_educator, notice: 'Educator was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @netball_educator.destroy
    redirect_to netball_educators_url, notice: 'Educator was successfully deleted.'
  end

  private

  def set_netball_educator
    @netball_educator = NetballEducator.find(params[:id])
  end

  def netball_educator_params
    params.require(:netball_educator).permit(
      :first_name, 
      :last_name, 
      :email, 
      :phone, 
      :title,
      :school_name,
      :address,
      :zip,
      :website,
      :level,
      :educator_notes,
      :feedback,
      :authorize,
      :user_id,
      :mgmt_notes,
      :city,
      :state
    )
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def base_scope
    if current_user.admin?
      NetballEducator.all
    else
      NetballEducator.where(user_id: current_user.id)
    end
  end

  def set_users
    #special group defined in helpers
    @users = User.active_educator_users
  end
end 
 