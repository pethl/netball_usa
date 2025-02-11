class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]
  load_and_authorize_resource


  def people_search
    if params[:search].blank?
     # redirect_to search_path and return
      @people = Array.new
      return 
    else
      @parameter = params[:search].downcase
      @people_first = Person.all.where("lower(last_name) LIKE :search", search: "%#{@parameter}%")
      @people_last= Person.all.where("lower(first_name) LIKE :search", search: "%#{@parameter}%")
      @people= @people_first+@people_last
      if @people.count==0
       @people=0
       return
      elsif @people.count==1
          @person = @people
          redirect_to @person
      end
    end
  end
 

  # GET /umpires
  def index
   # authorize! :read, @people
    authorize! :manage, Person
     @people = Person.where(role: "Umpire", region: "US & Canada")
     @people =  @people.order(first_name: :asc)
  end
  
  def index_int
      @people = Person.where(role: "Umpire", region: "International")
      @people =  @people.order(first_name: :asc)
  end 
  
  def index_scorers
      @people = Person.where(role: "Scorer")
      @people =  @people.order(first_name: :asc)
  end 
  
  def index_trainers_and_ambassadors
      @people = Person.where(role: "Trainer").or(Person.where(role: "Ambassador"))
      @people =  @people.order(first_name: :asc)
   end

   def index_coaches
     @people = Person.where(role: "Coach")
     @people =  @people.order(first_name: :asc)
   end
 
    def index_operations
      @people = Person.where(role: "Operations")
      @people =  @people.order(first_name: :asc)
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
      person_params = params.require(:person).permit(:name, :email, frequent_flyer_numbers_attributes: [:id, :airline, :number, :_destroy])

       # Log the parameters to check their structure
  Rails.logger.debug("Person Params: #{params.inspect}")

      # Ensure we're checking each ffn correctly
      person_params[:frequent_flyer_numbers_attributes].reject! do |index, ffn|
        ffn[:airline].blank? && ffn[:number].blank?
      end
    
      person_params
    end

    def get_future_events
      @events = Event.where("date > ?", Time.now - 1.month).order(date: :asc)
    end
end
