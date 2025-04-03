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
      @role = params[:role].presence || "Umpire"
      @region =
        if params[:region].present?
          params[:region]
        elsif params[:role].blank? || params[:role] == "Umpire"
          "US & Canada"
        else
          nil
        end
    
      @status = params[:status]
      @searching = params[:search].present?
    
      if @searching
        q = params[:search].downcase
        @people = Person.where("LOWER(first_name) LIKE :q OR LOWER(last_name) LIKE :q OR LOWER(email) LIKE :q", q: "%#{q}%")
      else
        @people = Person.all
        
        # If status is present (for Inactive tab), filter by status
        if @status.present?
          @people = @people.where(status: @status)
        else
          # For all other tabs, only show Active people
          @people = @people.where(status: "Active")
          # Then filter by role and region
          @people = @people.where(role: @role)
          @people = @people.where(region: @region) if @region.present?
        end
      end
    
      @people = @people.ordered
    
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("people_list", partial: "people/people_table", locals: {
              people: @people,
              searching: @searching,
              search_term: params[:search]
            }),
            turbo_stream.replace("people_filters_nav", partial: "people/people_filters_nav")
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
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
    @events = get_future_events
    @person.frequent_flyer_numbers = @person.frequent_flyer_numbers.reject { |ffn| ffn.airline.blank? && ffn.number.blank? }

    if @person.update(person_params)

      redirect_to @person, notice: "Person was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
    redirect_to people_url, notice: "Person was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      person_params= params.require(:person).permit(:first_name, :last_name, :status, :role, :region, :location, :email, :level, :level_note, :level_submitted, :phone, :address, :associated, :gender, :tshirt_size, :uniform_size, :headshot, :headshot_path, :description, :image, :accept_notes, :notes, :in_person_trained, :virtually_trained, :booth_trained, :headshot_present, :certification, :certification_date, :resume, event_ids: [], frequent_flyer_numbers_attributes: [:id, :airline, :number, :_destroy])
     
      # Add invite_back only for admin users
      person_params[:invite_back] = params.dig(:person, :invite_back) if current_user&.admin?
    
      # Ensure we're checking each ffn correctly
      person_params[:frequent_flyer_numbers_attributes].reject! do |index, ffn|
        ffn[:airline].blank? && ffn[:number].blank?
      end
    
      person_params
    end

    def get_future_events
      @events = Event.where("date > ?", Time.now - 1.month).order(date: :asc)
    end

    def region_for(role, param_region)
      return param_region if role == "Umpire" && param_region.present?
      return "US & Canada" if role == "Umpire"
      nil
    end
    
end
