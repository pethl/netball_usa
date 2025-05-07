class EventsController < ApplicationController
  include EventsHelper
  helper EventsHelper

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

  def assign_educators
    @event = Event.find(params[:id])
  
    if request.get?
      @educators = NetballEducator.all
      render :assign_educators
    else
      educator_ids = Array.wrap(params[:educator_ids])
  
      educator_ids.each do |educator_id|
        educator = NetballEducator.find_by(id: educator_id)
  
        if educator.present?
          EventParticipant.find_or_create_by!(
            event: @event,
            netball_educator: educator
          )
        else
          Rails.logger.warn "Educator with ID #{educator_id} not found"
        end
      end
  
      #SWAPPED FROM JSON BLOCK TO FORCE PAGE REFRESH TO SHOW USRE UPDATED CHECKBOXES
      respond_to do |format|
       format.json { render json: { success: true, reload: true  } }
       format.html { redirect_to @event, notice: 'Educators assigned successfully.' }
      end
  
    end
  end

  def calendar
    @year = params[:year]&.to_i || Date.current.year
    @events = Event.all  # or scope this if needed
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
      params.require(:event).permit(:event_type, :is_educational,:name, :date, :end_date, :proposal_submission_due, :booth_registration_due, :attend, :website, :key_contact, :city, :state, :location, :details, :booth, :cost_notes, :status, :outcome, person_ids: [], netball_educator_ids: [])
    end

    def filtered_events(upcoming:)
      base_scope = upcoming ? Event.upcoming : Event.past
      apply_event_filters(base_scope)
    end
    
    def filtered_educational_events(upcoming:)
      base_scope = upcoming ? Event.educational.upcoming : Event.educational.past
      apply_event_filters(base_scope)
    end

    def apply_event_filters(scope)
      scope = scope.where('city ILIKE ?', "%#{params[:city]}%") if params[:city].present?
      scope = scope.where(state: params[:state]) if params[:state].present?
      scope = scope.where(event_type: params[:event_type]) if params[:event_type].present?
      scope
    end
end
