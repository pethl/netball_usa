class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  def print_details_pdf
    people = Person.where(role: "Umpire")
    .where("region ILIKE ?", "%US & Canada%")
    .order(:last_name)    
    pdf = PeoplePdfService.new(people).generate
  
    send_data pdf.render,
              filename: "people_details.pdf",
              type: "application/pdf",
              disposition: "inline"
  end
 
  def index
    # ----------------------------
    # 1) Read tab/filter parameters
    # ----------------------------
  
    # Which tab are we on? If no role is provided, default to "Umpire" tab.
    # Note: the "All People" tab passes role="All".
    @role = params[:role].presence || "All"
  
    # Region selection logic:
    # - If role is "All": no region filter applies (nil)
    # - Else, use explicit region param if present
    # - Else, when landing on default/umpire tab with no explicit region, default to "US & Canada"
    # - Else: no region filter
    @region =
      if @role == "All"
        nil
      elsif params[:region].present?
        params[:region]
      elsif params[:role].blank? || params[:role] == "Umpire"
        "US & Canada"
      else
        nil
      end
  
    # Status filter (e.g., "Active", "Inactive"); nil means "no explicit status requested"
    @status = params[:status].presence
  
    # Are we running a text search (name/email)?
    @searching = params[:query].present?
  
    # Start with all records; we’ll chain filters onto this relation.
    scope = Person.all
  
    # --------------------------------------------------------
    # 2) Status + Role/Region rules (the heart of the behaviour)
    # --------------------------------------------------------
    #
    # Rules:
    # A) If a status is explicitly given (e.g., ?status=Inactive):
    #    - Filter by that status.
    #    - Only apply role/region if a role param was explicitly provided AND it's not "All".
    #
    # B) If no status is given:
    #    - On "All People" tab (role=All): show ALL statuses (no status filter).
    #    - On any specific role tab: default to status "Active" and apply role/region filters.
  
    if @status.present?
      # A) Explicit status filter
      scope = scope.where(status: @status)
  
      if params[:role].present? && @role != "All"
        scope = scope.where(role: @role)
        scope = scope.where(region: @region) if @region.present?
      end
    else
      # B) No explicit status
      if @role == "All"
        # Show all statuses; no status filter here.
      else
        # Specific role tab without a status param defaults to Active in that role/region.
        scope = scope.where(status: "Active")
        scope = scope.where(role: @role)
        scope = scope.where(region: @region) if @region.present?
      end
    end
  
    # -----------------------------------------
    # 3) Text query: name/email (case-insensitive)
    # -----------------------------------------
    if @searching
      q = "%#{params[:query].downcase}%"
      scope = scope.where(
        "LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(email) LIKE :q",
        q: q
      )
    end
  
    # ------------------------
    # 4) Location field filters
    # ------------------------
    # State: select value is a 2-letter code (e.g., "NY", "CA") from references/us_states
    scope = scope.where(state: params[:state]) if params[:state].present?
  
    # City/Country: partial, case-insensitive matches
    scope = scope.where("LOWER(city) LIKE ?",    "%#{params[:city].downcase}%")    if params[:city].present?
    scope = scope.where("LOWER(country) LIKE ?", "%#{params[:country].downcase}%") if params[:country].present?
  
    # -----------------------
    # 5) Final ordering & set
    # -----------------------
    # Assumes Person.ordered is a scope like: order(:last_name, :first_name) (or whatever you define)
    @people = scope.ordered
  
    # --------------------------------------------
    # 6) Response: full HTML vs Turbo Stream update
    # --------------------------------------------
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: [
          # Replace the results table with the newly filtered list
          turbo_stream.replace(
            "people_list",
            partial: "people/people_table",
            locals: { people: @people, searching: @searching, search_term: params[:query] }
          ),
  
          # Replace the tabs/nav partial (keeps active state accurate after param changes)
          turbo_stream.replace(
            "people_filters_nav",
            partial: "people/people_filters_nav"
          )
  
          # If you also want the filters’ inputs to re-render (e.g., after Clear),
          # uncomment the next block and ensure the filters are wrapped in a frame with id "people_filters":
          # turbo_stream.replace(
          #   "people_filters",
          #   partial: "people/people_filters"
          # )
        ]
      end
    end
  end
  
 
  # GET /people/1
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
    # Always build 3 FrequentFlyerNumber records (even if they are empty)
    3.times { @person.frequent_flyer_numbers.build }
    @events = get_future_events
  end

  # GET /people/1/edit
  def edit
   # @person.frequent_flyer_numbers.build if @person.frequent_flyer_numbers.empty? # Ensure a field is present
   3.times { @person.frequent_flyer_numbers.build if @person.frequent_flyer_numbers.size < 3 } 
   @events = get_future_events
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    @person.frequent_flyer_numbers = @person.frequent_flyer_numbers.reject { |ffn| ffn.airline.blank? && ffn.number.blank? }


    if @person.save
      redirect_to @person, notice: "Person was successfully created."
    else
      @events = get_future_events  # ← Ensures form doesn't break
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
   
    @person.frequent_flyer_numbers = @person.frequent_flyer_numbers.reject { |ffn| ffn.airline.blank? && ffn.number.blank? }

    if @person.update(person_params)

      redirect_to @person, notice: "Person was successfully updated.", status: :see_other
    else
      @events = get_future_events
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    begin
      @person.destroy
      respond_to do |format|
        format.html { redirect_to people_url, notice: "Person was successfully destroyed.", status: :see_other }
        format.turbo_stream { redirect_to people_url, notice: "Person was successfully destroyed.", status: :see_other }
      end
    rescue ActiveRecord::InvalidForeignKey => e
      respond_to do |format|
        format.html { redirect_to @person, alert: "Cannot delete this person because they are linked to other records." }
        format.turbo_stream { redirect_to @person, alert: "Cannot delete this person because they are linked to other records." }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      person_params= params.require(:person).permit(:first_name, :last_name, :status, :role, :educator_role, :region, :location, :city, :state, :country, :email, :level, :level_note, :level_submitted, :phone, :address, :associated, :gender, :tshirt_size, :uniform_size,  :inferno_top_polo_size, :inferno_top_vneck_size, :inferno_bottom_skirt_size, :inferno_bottom_shorts_size, :invite_back,:headshot, :headshot_path, :description, :image, :accept_notes, :notes, :in_person_trained, :virtually_trained, :booth_trained, :headshot_present, :certification, :certification_date, :resume, event_ids: [], frequent_flyer_numbers_attributes: [:id, :airline, :number, :_destroy])
     
      # Add invite_back only for admin users
      person_params[:invite_back] = params.dig(:person, :invite_back) if current_user&.admin?
    
      # Ensure we're checking each ffn correctly
      person_params[:frequent_flyer_numbers_attributes].reject! do |index, ffn|
        ffn[:airline].blank? && ffn[:number].blank?
      end
    
      person_params
    end

    def get_future_events
      Event.where("date > ?", Time.now - 1.month).order(date: :asc) || []
    end

    def region_for(role, param_region)
      return param_region if role == "Umpire" && param_region.present?
      return "US & Canada" if role == "Umpire"
      nil
    end
    
end
