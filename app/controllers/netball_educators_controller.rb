class NetballEducatorsController < ApplicationController
  include Pagy::Backend

  skip_before_action :authenticate_user!, only: [:show, :create]
  before_action :set_netball_educator, only: [:show, :edit, :update, :destroy]
  before_action :set_users, only: [:new, :create, :edit, :update]

  def index
    # used for the modal
    # @events = Event.educational.gone
  
    @events = Event.educational.ordered_desc
  
    # 🔥 Educator Access Control
    @netball_educators = NetballEducator.all
    apply_common_filters!
  
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
    @netball_educators = NetballEducator
      .where(role: "PE Director")
      .or(NetballEducator.where(is_pe_director: true))
  
    apply_common_filters!
  end
  
  def kidos
    @netball_educators = NetballEducator.where(role: "Kidokinetics")
    apply_common_filters!
  end
  
  def talentlockr
    @netball_educators = NetballEducator.where(role: "Talentlockr")
    apply_common_filters!
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
    @educator_ids_with_participants = EventParticipant.where(netball_educator_id: @netball_educators.pluck(:id)).distinct.pluck(:netball_educator_id).to_set

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
  
    if params[:role].present?
      @netball_educator.role = params[:role]
    elsif params[:kidokinetics] == "true"
      @netball_educator.role = "Kidokinetics"
    end
  
    @netball_educator.level = "Franchise"
  end

  def edit
  end

  def create
    @netball_educator = NetballEducator.new(netball_educator_params)

    # Manually assign associated events (via event_participants)
    assign_events_to_educator(@netball_educator)


    # Safer and more parseable logging
      Rails.logger.info({
        tag: "NETBALL_EDUCATOR_SUBMISSION",
        timestamp: Time.current.iso8601,
        params: params[:netball_educator]
      }.to_json)

    if @netball_educator.save
      redirect_to @netball_educator, notice: 'Educator was successfully created.'
    else
      Rails.logger.error("[EducatorCreateError] Validation failed: #{@netball_educator.errors.full_messages.to_sentence}")

      render :new
    end
  end

  def update
    @netball_educator.assign_attributes(netball_educator_params.except(:event_ids))
  
    # Re-assign selected events
    assign_events_to_educator(@netball_educator)
  
    if @netball_educator.save
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
      :role,
      :educator_notes,
      :feedback,
      :authorize,
      :user_id,
      :mgmt_notes,
      :city,
      :state,
      event_ids: []
    )
  end

  def assign_events_to_educator(educator)
    event_ids = Array(params[:netball_educator][:event_ids]).reject(&:blank?)
    educator.events = Event.where(id: event_ids)
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

  def apply_common_filters!
    @netball_educators = @netball_educators.where(state: params[:state]) if params[:state].present?
    @netball_educators = @netball_educators.where(city: params[:city]) if params[:city].present?
  
    if params[:query].present?
      q = "%#{params[:query]}%"
      @netball_educators = @netball_educators.where(
        "first_name ILIKE :q OR last_name ILIKE :q OR email ILIKE :q",
        q: q
      )
    end
  
    if params[:created_at].present?
      @netball_educators = @netball_educators.where(
        "DATE(created_at) = ?", params[:created_at]
      )
    end
  
    @netball_educators = @netball_educators.order(:state, :city, :first_name)
  
    @educator_ids_with_participants =
      EventParticipant
        .where(netball_educator_id: @netball_educators.pluck(:id))
        .distinct
        .pluck(:netball_educator_id)
        .to_set
  end
  
end 
 