class UmpiresController < ApplicationController
  before_action :set_umpire, only: %i[ show edit update destroy ]

  # GET /umpires
  def index
    @umpires = Umpire.all
  end

  # GET /umpires/1
  def show
  end

  # GET /umpires/new
  def new
    @umpire = Umpire.new
  end

  # GET /umpires/1/edit
  def edit
  end

  # POST /umpires
  def create
    @umpire = Umpire.new(umpire_params)

    if @umpire.save
      redirect_to @umpire, notice: "Umpire was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /umpires/1
  def update
    if @umpire.update(umpire_params)
      redirect_to @umpire, notice: "Umpire was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /umpires/1
  def destroy
    @umpire.destroy
    redirect_to umpires_url, notice: "Umpire was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_umpire
      @umpire = Umpire.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def umpire_params
      params.require(:umpire).permit(:first_name, :last_name, :role, :region, :location, :email, :level, :level_note, :phone, :address, :associated, :gender, :tshirt_size, :uniform_size, :headshot, :headshot_file, :invite_back, :notes)
    end
end
