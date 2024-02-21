class EducatorsController < ApplicationController
  before_action :set_educator, only: %i[ show edit update destroy ]
   skip_before_action :authenticate_user!, only:[:show, :create]

  # GET /educators
  def index
    @educators = Educator.all
  end

  # GET /educators/1
  def show
  end

  # GET /educators/new
  def new
    @educator = Educator.new
    @users = User.all
  end

  # GET /educators/1/edit
  def edit
     @users = User.all
  end

  # POST /educators
  def create
    @educator = Educator.new(educator_params)

    if @educator.save
      redirect_to @educator, notice: "Educator was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /educators/1
  def update
    if @educator.update(educator_params)
      redirect_to @educator, notice: "Educator was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /educators/1
  def destroy
    @educator.destroy
    redirect_to educators_url, notice: "Educator was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_educator
      @educator = Educator.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def educator_params
      params.require(:educator).permit(:first_name, :last_name, :email, :phone, :school_name, :city, :state, :educator_notes, :mgmt_notes, :user_id)
    end
end
