class NetballEducatorsController < ApplicationController

  before_action :set_netball_educator, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :admin_user, only: [:destroy, :new, :create, :edit, :update]
  before_action :set_users, only: [:new, :create, :edit, :update]

  def index
    # Force HTML if Turbo tries to send Turbo Stream requests
    request.format = :html if request.format.turbo_stream?
  
    # 🔥 Educator Access Control
    @netball_educators = if is_admin? || current_user.role == "educators" || current_user.email == "drmarlene@netballamerica.com"
      NetballEducator.all
    else
      NetballEducator.where(user_id: current_user.id)
    end
  
    # 🔥 Filters
    if params[:state].present?
      @netball_educators = @netball_educators.where(state: params[:state])
    end
  
    if params[:city].present?
      @netball_educators = @netball_educators.where("city ILIKE ?", "%#{params[:city]}%")
    end
  
    # 🔥 Ordering
    @netball_educators = @netball_educators.order(:state, :city, created_at: :desc)
  
    respond_to do |format|
      format.html
      format.xlsx
    end
  end  

  def pe_directors
    if (is_admin? || current_user.role=="educators" || current_user.email=="drmarlene@netballamerica.com")
      @netball_educators = NetballEducator.all.where(level: "School/District Lead")
      @netball_educators = @netball_educators.order("created_at DESC, state ASC, city ASC")
    else
      @netball_educators = []
    end
  end

  def my_educators
    @netball_educators = NetballEducator.where(user_id: current_user.id)
    @netball_educators = @netball_educators.order("created_at DESC, state ASC, city ASC")
  end

  def search
    if params[:search].present?
      query = params[:search]
      @netball_educators = NetballEducator.where("first_name ILIKE ? OR last_name ILIKE ?", "%#{query}%", "%#{query}%").order(:first_name)
    else
      @netball_educators = []
    end
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
      redirect_to @netball_educator, notice: 'Netball educator was successfully created.'
    else
      render :new
    end
  end

  def update
    if @netball_educator.update(netball_educator_params)
      redirect_to @netball_educator, notice: 'Netball educator was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @netball_educator.destroy
    redirect_to netball_educators_url, notice: 'Netball educator was successfully deleted.'
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
    @users = User.active_admins
  end
end 
 