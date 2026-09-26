class PartnersController < ApplicationController
  before_action :set_partner, only: %i[ show edit update destroy ]
  before_action :set_allocation_users,
              only: [:new, :create, :edit, :update]
  load_and_authorize_resource

  # GET /partners
  def index
    @partners = apply_search(Partner.all.ordered)
  end
  
  def my_partners
    @partners = apply_search(
      Partner.where(user_id: current_user.id).ordered
    )
    render :index
  end

  # GET /partners/1
  def show
    @contacts = @partner.contacts.ordered
  end

  # GET /partners/new
  def new
    @partner = Partner.new(
      user_id: current_user.id,
      old_user_id: current_user.id
    )

  end

  # GET /partners/1/edit
  def edit
    @contacts = @partner.contacts.ordered
  end

  # POST /partners
  def create
    @partner = Partner.new(partner_params)

    # Use the current user when no allocation was selected.
    @partner.user_id ||= current_user.id

    # Remember who created/allocated the record.
    @partner.old_user_id = current_user.id

    if @partner.save
      send_allocation_email(@partner)

      redirect_to @partner,
                  notice: "Partner was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /partners/1
  def update
    previous_user_id = @partner.user_id

    if @partner.update(partner_params)
      @partner.update(old_user_id: previous_user_id) if @partner.user_id != previous_user_id
    send_allocation_email(@partner)
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

  def university
  @partners = apply_search(
    Partner
      .where(usa_university_partner: true)
      .ordered
  )

  @page_title = "USA University Partners"
  @usa_university_view = true

  render :index
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_partner
      @partner = Partner.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def partner_params
      params.require(:partner).permit(:company, :user_id, :usa_university_partner, :description, :location, :city, :us_state, :country, :zip_code, :website, :date_initially_connected, :date_pitch_to_na, :date_pitch_by_na, :pitch_to_na, :pitch_by_na, :follow_up_action, :partnership_agreement, :accept_partnership, :date_of_decision, :first_name_primary, :last_name_primary, :role_primary, :email_primary, :cell_primary, :work_phone_primary, :first_name_secondary, :last_name_secondary, :role_secondary, :email_secondary, :cell_secondary, :work_phone_secondary, :first_name_third, :last_name_third, :role_third, :email_third, :cell_third, :work_phone_third )
    end

    def send_allocation_email(partner)
      unless partner.user_id == partner.old_user_id
        PartnerMailer.with(partner: partner).record_allocation_notification.deliver_later
      end
    end


    def apply_search(scope)
      search_term = params[:query].presence || params[:search].presence
      return scope unless search_term.present?

      q = "%#{search_term}%"

      scope.where(
        "company ILIKE :q
        OR city ILIKE :q
        OR us_state ILIKE :q
        OR zip_code ILIKE :q
        OR country ILIKE :q",
        q: q
      )
    end

    def set_allocation_users
      @users = (
        helpers.active_admin_users.to_a + [current_user]
      ).uniq(&:id).sort_by do |user|
        user.first_name.to_s.downcase
      end
    end

end
