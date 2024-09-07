class PartnersController < ApplicationController
  before_action :set_partner, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /partners
  def index
    @partners = Partner.all
  end

  # GET /partners/1
  def show
    @contacts = @partner.contacts.ordered
  end

  # GET /partners/new
  def new
    @partner = Partner.new
  end

  # GET /partners/1/edit
  def edit
    @contacts = @partner.contacts.ordered
  end

  # POST /partners
  def create
    @partner = Partner.new(partner_params)

    if @partner.save
      redirect_to @partner, notice: "Partner was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /partners/1
  def update
    if @partner.update(partner_params)
      redirect_to @partner, notice: "Partner was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /partners/1
  def destroy
    @partner.destroy
    redirect_to partners_url, notice: "Partner was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
      @partner = Partner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def partner_params
      params.require(:partner).permit(:company, :description, :location, :city, :us_state, :country, :website, :date_initially_connected, :date_pitch_to_na, :date_pitch_by_na, :pitch_to_na, :pitch_by_na, :follow_up_action, :partnership_agreement, :accept_partnership, :date_of_decision, :first_name_primary, :last_name_primary, :role_primary, :email_primary, :cell_primary, :work_phone_primary, :first_name_secondary, :last_name_secondary, :role_secondary, :email_secondary, :cell_secondary, :work_phone_secondary, :first_name_third, :last_name_third, :role_third, :email_third, :cell_third, :work_phone_third )
    end
end
