class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]


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
   
  
 
  # GET /people/1
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to @person, notice: "Person was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /people/1
  def update
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
      params.require(:person).permit(:first_name, :last_name, :role, :region, :location, :email, :level, :level_note, :phone, :address, :associated, :gender, :tshirt_size, :uniform_size, :headshot, :headshot_path, :description, :image, :invite_back, :accept_notes, :notes, :in_person_trained, :virtually_trained, :booth_trained, :headshot_present, :certification, :certification_date)
    end
end
