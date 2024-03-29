class GrantsController < ApplicationController
  before_action :set_grant, only: %i[ show edit update destroy ]

  # GET /grants
  def index
    @grants = Grant.all
  end

  # GET /grants/1
  def show
  end

  # GET /grants/new
  def new
    @grant = Grant.new
  end

  # GET /grants/1/edit
  def edit
  end

  # POST /grants
  def create
    @grant = Grant.new(grant_params)

    if @grant.save
      redirect_to @grant, notice: "Grant was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /grants/1
  def update
    if @grant.update(grant_params)
      redirect_to @grant, notice: "Grant was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /grants/1
  def destroy
    @grant.destroy
    redirect_to grants_url, notice: "Grant was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grant
      @grant = Grant.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grant_params
      params.require(:grant).permit(:name, :apply, :amount, :location, :due_date, :purpose, :grant_link, :notes, :status, :date_submitted, :program, :application_link, :login, :user_id)
    end
end
