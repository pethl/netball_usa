class ProgramsController < ApplicationController
  before_action :set_program, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /programs
  def index
    @programs = Program.all.order(program_name: :asc)
    @people = Person.all
  end

  # GET /programs/1
  def show
  end

  # GET /programs/new
  def new
    @program = Program.new
    @people = Person.where(role: "Coach").or(Person.where(role: "Ambassador"))
    @people = @people.order(last_name: :asc)
  end

  # GET /programs/1/edit
  def edit
    @people = Person.where(role: "Coach").or(Person.where(role: "Ambassador"))
    @people = @people.order(last_name: :asc)
  end

  # POST /programs
  def create
    @program = Program.new(program_params)
    @people = Person.where(role: "Coach").or(Person.where(role: "Ambassador"))

    if @program.save
      redirect_to @program, notice: "Program was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /programs/1
  def update
    if @program.update(program_params)
      redirect_to @program, notice: "Program was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /programs/1
  def destroy
    @program.destroy
    redirect_to programs_url, notice: "Program was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_program
      @program = Program.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def program_params
      params.require(:program).permit(:program_stage, :program_name, :na_program_contact_email, :na_program_contact_phone, :location_name, :location_contact_phone, :location_contact_email, :address, :city, :state, :zip, :country, :person_id, :program_event_datetime, :timezone, :funded_by, :notes)
    end
end
