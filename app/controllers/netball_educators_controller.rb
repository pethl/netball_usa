class NetballEducatorsController < ApplicationController
  before_action :set_netball_educator, only: %i[ show edit update destroy ]
   skip_before_action :authenticate_user!, only:[:show, :create]

   def search
     if params[:search].blank?
      # redirect_to search_path and return
       @netball_educators= Array.new
       return 
     else
       @parameter = params[:search].downcase
       @netball_educators_last = NetballEducator.all.where("lower(last_name) LIKE :search", search: "%#{@parameter}%")
       @netball_educators_first = NetballEducator.all.where("lower(first_name) LIKE :search", search: "%#{@parameter}%")
       @netball_educators = @netball_educators_last + @netball_educators_first 
     end
       if @netball_educators.count==0
       @netball_educators=0
       return
      end
    end
  
  # GET /netball_educators
  def index
    if (is_admin? || current_user.role=="educators")
       @netball_educators = NetballEducator.all
       @netball_educators = @netball_educators.order("created_at DESC, state ASC, city ASC")
    else
        @netball_educators = NetballEducator.where(user_id: current_user.id)
        @netball_educators = @netball_educators.order(created_at: :desc)
      end

      respond_to do |format|
        format.html
        format.xlsx
      end
  end

  # GET /netball_educators
  def index_state
    if (is_admin? || current_user.role=="educators")
       @netball_educators = NetballEducator.all
       @netball_educators_by_state = @netball_educators.order("state ASC, city ASC").group_by(&:state)
      
    else
        @netball_educators = NetballEducator.where(user_id: current_user.id).where('level != ?', "School/District Lead")
        @netball_educators = @netball_educators.order(state: :asc)
        @netball_educators_by_state = @netball_educators.group_by { |t| t.state }
      end

      respond_to do |format|
        format.html
        format.xlsx
      end
  end

  def index_user
    if (is_admin? || current_user.role=="educators")
       @netball_educators = NetballEducator.all
       @netball_educators = @netball_educators.order(user_id: :asc)
       @netball_educators_by_user = @netball_educators.group_by { |t| t.user_id }
      
    else
        @netball_educators = NetballEducator.where(user_id: current_user.id).where('level != ?', "School/District Lead")
        @netball_educators = @netball_educators.order(user_id: :asc)
        @netball_educators_by_user = @netball_educators.group_by { |t| t.user_id }
      end
  end
  
  def index_level
    if (is_admin? || current_user.role=="educators")
        @netball_educators = NetballEducator.all
        @netball_educators_by_level = @netball_educators.order("level ASC, state ASC, city ASC").group_by(&:level)
      
     
    else
        @netball_educators = NetballEducator.where(user_id: current_user.id)
        @netball_educators = @netball_educators.order(level: :asc)
        @netball_educators_by_level = @netball_educators.group_by { |t| t.level }
      end
  end

  def pe_directors
    if is_admin? 
        @netball_educators = NetballEducator.where(is_pe_director: true)
        @netball_educators = @netball_educators.order(state: :asc, first_name: :asc)
       
    else
        @netball_educators = NetballEducator.where(user_id: current_user.id).where(is_pe_director: true)
        @netball_educators = @netball_educators.order(state: :asc)
      end
  end

  # GET /netball_educators/1
  def show
  end

  # GET /netball_educators/new
  def new
    @netball_educator = NetballEducator.new
    @users = helpers.active_admin_users
  end

  # GET /netball_educators/1/edit
  def edit
     @users = helpers.active_admin_users
  end

  # POST /netball_educators
  def create
    @netball_educator = NetballEducator.new(netball_educator_params)

    if @netball_educator.save
      redirect_to @netball_educator, notice: "Record saved successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /netball_educators/1
  def update
    if @netball_educator.update(netball_educator_params)
      redirect_to @netball_educator, notice: "Record was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /netball_educators/1
  def destroy
    @netball_educator.destroy
    redirect_to netball_educators_url, notice: "Record was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_netball_educator
      @netball_educator = NetballEducator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def netball_educator_params
      params.require(:netball_educator).permit(:feedback, :first_name, :last_name, :title, :level, :website, :authorize, :user_id, :email, :phone, :school_name, :address, :city, :state, :zip, :is_pe_director, :educator_notes, :mgmt_notes)
    end
end
 