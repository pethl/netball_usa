class EventsController < ApplicationController
  before_action :set_event_collections, only: %i[ new show edit update ]
  before_action :set_event, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /events
  def index
    
    @events = Event.all
    @events = @events.order(date: :desc)
    @events_by_year = @events.group_by { |t| t.event_date_year }
  end
  
  # GET /events
  def calendar
    @events = Event.all
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @people = Person.where(role: "Trainer").or(Person.where(role: "Ambassador"))
    @people = @people.order(last_name: :asc)
  end

  # GET /events/1/edit
  def edit
    @people = Person.where(role: "Trainer").or(Person.where(role: "Ambassador"))
    @people = @people.order(role: :asc).order(last_name: :asc)
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      @people = Person.all
      @people = @people.order(last_name: :asc)
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: "Event was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end
    
    # Get event list for drop down.
    def set_event_collections
      @people= Person.all
      @people = @people.order(last_name: :asc)
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:event_type, :name, :date, :end_date, :website, :key_contact, :city, :state, :location, :details, :booth, :cost_notes, :status, :outcome, person_ids: [])
    end
end
