class NetballEducatorsController < ApplicationController
  before_action :set_netball_educator, only: %i[ show edit update destroy ]
   skip_before_action :authenticate_user!, only:[:show, :create]

  # GET /netball_educators
  def index
    if is_admin? 
       @netball_educators = NetballEducator.all
    else
        @netball_educators = NetballEducator.where(user_id: current_user.id)
      end
  end

  # GET /netball_educators/1
  def show
  end

  # GET /netball_educators/new
  def new
    @netball_educator = NetballEducator.new
     @users = User.all
  end

  # GET /netball_educators/1/edit
  def edit
     @users = User.all
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
      params.require(:netball_educator).permit(:feedback, :first_name, :last_name, :authorize, :user_id, :email, :phone, :school_name, :city, :state, :educator_notes, :mgmt_notes)
    end
end
