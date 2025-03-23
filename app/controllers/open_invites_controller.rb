class OpenInvitesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_open_invite, only: %i[ show edit update destroy ]
  load_and_authorize_resource


  # GET /open_invites
  def index
    @open_invites = OpenInvite.includes(:person).all
    @people = Person.all.ordered
    @highlight_id = flash[:highlight_id] # 💥 extract before rendering
  end

  # GET /open_invites/1
  def show
    render partial: "open_invite_row", locals: { open_invite: @open_invite }
  end

  # GET /open_invites/new
  def new
    @people = Person.all.ordered
    @open_invite = OpenInvite.new
  end

  # GET /open_invites/1/edit
  def edit
    @people = Person.all.ordered
    render turbo_stream: turbo_stream.replace(dom_id(@open_invite),
      partial: "edit_row",
      locals: { open_invite: @open_invite, people: @people }
    )
  end
  

  # POST /open_invites
  def create
    @open_invite = OpenInvite.new(open_invite_params)

    if @open_invite.save
      # store ID in flash temporarily
      flash[:highlight_id] = @open_invite.id
      redirect_to open_invites_path
    else
      @people = Person.all
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /open_invites/1
  def update
    if @open_invite.update(open_invite_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to open_invites_path }
      end
    else
      @people = Person.all.ordered
    render turbo_stream: turbo_stream.replace(dom_id(@open_invite),
      partial: "edit_row",
      locals: { open_invite: @open_invite, people: @people }
    )
    end
  end

  # DELETE /open_invites/1
  def destroy
    @open_invite.destroy!
    redirect_to open_invites_url, notice: "Open invite was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_open_invite
      @open_invite = OpenInvite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def open_invite_params
      params.require(:open_invite).permit(:status, :invite_sent, :invite_sent_date, :rspv, :whova, :flight_booked, :sent_save_the_date, :response_to_save_the_date, :send_official_invite, :comments, :person_id)
    end
end
