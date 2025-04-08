class EventsController < ApplicationController
  include EventsHelper

  before_action :set_event_collections, only: %i[ new show edit update ]
  before_action :set_event, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /events
  def index
    @events = filtered_events(upcoming: true).order(:date)
  end

  def index_past
    @events = filtered_events(upcoming: false).order(date: :desc)
    render :index
  end

  def educational
    @events = filtered_educational_events(upcoming: true).order(:date)
    render :educational
  end

  def educational_past
    @events = filtered_educational_events(upcoming: false).order(date: :desc)
    render :educational
  end

  def calendar
    @events = Event.all
  end

  def show
  end

  def new
    @event = Event.new
    @people = Person.active_trainers_and_ambassadors
  end

  def edit
    @people = Person.active_trainers_and_ambassadors
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      @people = Person.active_trainers_and_ambassadors
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      @people = Person.active_trainers_and_ambassadors
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_url, notice: "Event was successfully destroyed.", status: :see_other
  end

  private

    def set_event
      @event = Event.find(params[:id])
    end
    
    def set_event_collections
      @people = Person.active_trainers_and_ambassadors
    end

    def event_params
      params.require(:event).permit(:event_type, :name, :date, :end_date, :attend, :website, :key_contact, :city, :state, :location, :details, :booth, :cost_notes, :status, :outcome, person_ids: [])
    end

    def filtered_events(upcoming:)
      scope = if upcoming
        Event.where('date >= ?', Date.today.beginning_of_month)
      else
        Event.where('date <= ?', Date.today.beginning_of_month)
      end
  
      scope = scope.where('city ILIKE ?', "%#{params[:city]}%") if params[:city].present?
      scope = scope.where(state: params[:state]) if params[:state].present?
      scope = scope.where(event_type: params[:event_type]) if params[:event_type].present?
  
      scope
    end

    def filtered_educational_events(upcoming:)
      scope = if upcoming
        Event.educational.where('date >= ?', Date.today.beginning_of_month)
      else
        Event.educational.where('date <= ?', Date.today.beginning_of_month)
      end
    
      scope = scope.where('city ILIKE ?', "%#{params[:city]}%") if params[:city].present?
      scope = scope.where(state: params[:state]) if params[:state].present?
      scope = scope.where(event_type: params[:event_type]) if params[:event_type].present?
    
      scope
    end
end
