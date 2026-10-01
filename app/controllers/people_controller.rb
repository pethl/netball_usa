class PeopleController < ApplicationController
before_action :set_person, only: %i[show edit update]
load_and_authorize_resource except: :destroy

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

    if params[:role] == "University Squad"
      @person.role = "University Squad"

      @person.build_university_athlete_profile(
        registered_at: Date.current
      )
    end

    3.times do
      @person.frequent_flyer_numbers.build
    end

    @events = get_future_events
  end

  # GET /people/1/edit
  def edit
      if @person.role == "University Squad" &&
          @person.university_athlete_profile.blank?
        @person.build_university_athlete_profile
      end

      3.times do
        if @person.frequent_flyer_numbers.size < 3
          @person.frequent_flyer_numbers.build
        end
      end

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
      @person = Person.find_by(id: params[:id])

      unless @person
        redirect_to people_url(format: :html),
                    notice: "This person has already been deleted.",
                    status: :see_other
        return
      end

      authorize! :destroy, @person

      @person.destroy

      redirect_to people_url(format: :html),
                  notice: "Person was successfully deleted.",
                  status: :see_other
    rescue ActiveRecord::InvalidForeignKey
      redirect_to @person,
                  alert: "Cannot delete this person because they are linked to other records.",
                  status: :see_other
    end



  def university_squad
  scope = Person
    .where(role: "University Squad")
    .left_joins(:university_athlete_profile)
    .includes(:university_athlete_profile)

  if params[:view] == "future"
    scope = scope.where(
      "university_athlete_profiles.final_eligibility IS NULL
       OR university_athlete_profiles.final_eligibility NOT ILIKE ?",
      "Yes%"
    )
  else
    scope = scope.where(
      "university_athlete_profiles.final_eligibility ILIKE ?",
      "Yes%"
    )
  end

  if params[:country].present?
    scope = scope.where(
      "LOWER(people.country) LIKE ?",
      "%#{params[:country].downcase}%"
    )
  end

  if params[:state].present?
    scope = scope.where(people: { state: params[:state] })
  end

  if params[:city].present?
    scope = scope.where(
      "LOWER(people.city) LIKE ?",
      "%#{params[:city].downcase}%"
    )
  end

  if params[:college].present?
    scope = scope.where(
      "LOWER(university_athlete_profiles.usa_college) LIKE ?",
      "%#{params[:college].downcase}%"
    )
  end

  if params[:query].present?
    query = "%#{params[:query].downcase}%"

    scope = scope.where(
      <<~SQL.squish,
        LOWER(people.first_name) LIKE :query
        OR LOWER(people.last_name) LIKE :query
        OR LOWER(people.email) LIKE :query
      SQL
      query: query
    )
  end

  @people = scope.distinct.ordered
end

def location_map
  @selected_role = params[:role].presence || "All"
  @map_mode = params[:map] == "world" ? "world" : "usa"

  scope = Person.all

  if @selected_role != "All"
    scope = scope.where(role: @selected_role)
  end

  @map_context =
  if params[:context] == "university"
    "university"
  else
    "people"
  end

  @total_people_count = scope.count

  @people_state_counts = Hash.new(0)
  @country_counts = Hash.new(0)

  @non_usa_count = 0
  @missing_state_count = 0
  @missing_country_count = 0

  valid_state_codes = US_STATE_ABBREVIATIONS.values + ["DC"]

  usa_country_names = [
    "united states",
    "united states of america",
    "usa",
    "us",
    "u.s.",
    "u.s.a.",
    "america"
  ]

  scope.select(:id, :state, :country).find_each do |person|
    state = person.state.to_s.strip
    country = person.country.to_s.strip

    full_state_match = US_STATE_ABBREVIATIONS.find do |state_name, _code|
      state_name.casecmp?(state)
    end

    normalized_state =
      if full_state_match.present?
        full_state_match.last
      else
        state.upcase
      end

    valid_usa_state = valid_state_codes.include?(normalized_state)

    if valid_usa_state
      @people_state_counts[normalized_state] += 1
    elsif country.present? &&
          !usa_country_names.include?(country.downcase)
      @non_usa_count += 1
    else
      @missing_state_count += 1
    end

    normalized_country =
      if country.present?
        country
      elsif valid_usa_state
        "United States"
      end

    if normalized_country.present?
      @country_counts[normalized_country] += 1
    else
      @missing_country_count += 1
    end
  end

  @mapped_people_count = @people_state_counts.values.sum
  @mapped_country_count = @country_counts.values.sum
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
   def person_params
        permitted = params.require(:person).permit(
          :first_name,
          :last_name,
          :dob,
          :status,
          :role,
          :educator_role,
          :region,
          :location,
          :city,
          :state,
          :zip_code,
          :country,
          :email,
          :phone,
          :address,
          :gender,
          :associated,
          :level,
          :level_note,
          :level_submitted,
          :description,
          :notes,
          :accept_notes,
          :tshirt_size,
          :uniform_size,
          :inferno_top_polo_size,
          :inferno_top_vneck_size,
          :inferno_bottom_skirt_size,
          :inferno_bottom_shorts_size,
          :in_person_trained,
          :virtually_trained,
          :booth_trained,
          :headshot_present,
          :headshot,
          :headshot_path,
          :image,
          :certification,
          :certification_date,
          :resume,
          event_ids: [],
          frequent_flyer_numbers_attributes: [
            :id,
            :airline,
            :number,
            :_destroy
          ],
          university_athlete_profile_attributes: [
            :id,
            :registered_at,
            :american,
            :usa_college,
            :final_eligibility,
            :trial_fee_paid,
            :platform_fee,
            :net_fee,
            :netball_america_experience,
            :previous_netball_america_involvement,
            :netball_pathway_experience,
            :first_position,
            :second_position,
            :trial_format,
            :virtual_trial_footage,
            :trial_footage_explanation,
            :fast5_experience,
            :international_health_insurance,
            :emergency_contact
          ]
        )

        if current_user&.admin?
          permitted[:invite_back] = params.dig(
            :person,
            :invite_back
          )
        end

        if permitted[:frequent_flyer_numbers_attributes].present?
          permitted[:frequent_flyer_numbers_attributes].reject! do |_index, ffn|
            ffn[:airline].blank? &&
              ffn[:number].blank?
          end
        end

        permitted
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
