class PeopleController < ApplicationController
  before_action :set_person, only: %i[ show edit update destroy ]

  # GET /umpires
  def index
    @people = Person.where(role: "Umpire", region: "US & Canada")
  end
  
  def index_int
     @people = Person.where(role: "Umpire", region: "International")
  end 
  
  def index_scorers
     @people = Person.where(role: "Scorer")
  end 
  
  def index_trainers_and_ambassadors
     @people = Person.where(role: "Trainer").or(Person.where(role: "Ambassador"))
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
      params.require(:person).permit(:first_name, :last_name, :role, :region, :location, :email, :level, :level_note, :phone, :address, :associated, :gender, :tshirt_size, :uniform_size, :headshot, :description, :image, :invite_back, :accept_notes, :notes, :in_person_trained, :virtually_trained, :booth_trained)
    end
end
