class DonatedItemRequestsController < ApplicationController
 before_action :set_donated_item_request, only: %i[ show edit update destroy approve decline ]

  # GET /donated_item_requests
  def index
    @donated_item_requests = DonatedItemRequest.all
  end

  # GET /donated_item_requests/1
  def show
  end

  # GET /donated_item_requests/new
  def new
    @donated_item_request = DonatedItemRequest.new

    if params[:donated_item_id].present?
      @donated_item_request.donated_item =
        DonatedItem.find(params[:donated_item_id])
    end
  end

  # GET /donated_item_requests/1/edit
  def edit
  end

  # POST /donated_item_requests
  def create
    @donated_item_request = DonatedItemRequest.new(donated_item_request_params)
    @donated_item_request.requested_by = current_user
    @donated_item_request.status = "Pending"

    if @donated_item_request.valid?
      DonatedItemRequest.transaction do
        @donated_item_request.save!
        @donated_item_request.donated_item.update!(status: "Requested")
      end

      DonatedItemRequestMailer
        .with(request: @donated_item_request)
        .request_submitted
        .deliver_later

      redirect_to donated_items_path(status: "Requested"),
                  notice: "Donated item request was successfully submitted."
    else
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /donated_item_requests/1
  def update
    if @donated_item_request.update(donated_item_request_params)
      redirect_to @donated_item_request, notice: "Donated item request was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /donated_item_requests/1
  def destroy
    @donated_item_request.destroy!
    redirect_to donated_item_requests_url, notice: "Donated item request was successfully destroyed.", status: :see_other
  end

  def approve
    DonatedItemRequest.transaction do
      @donated_item_request.update!(
        donated_item_request_params.merge(
          status: "Approved",
          approved_by: current_user,
          approved_at: Time.current
        )
      )

      @donated_item_request.donated_item.update!(
        status: "Approved"
      )
    end

    DonatedItemRequestMailer
      .with(request: @donated_item_request)
      .request_approved
      .deliver_later

    redirect_to donated_item_request_path(@donated_item_request),
                notice: "Donated item request was approved.",
                status: :see_other
  end

  def decline
    DonatedItemRequest.transaction do
      @donated_item_request.update!(
        donated_item_request_params.merge(
          status: "Declined",
          approved_by: current_user,
          approved_at: Time.current
        )
      )

      @donated_item_request.donated_item.update!(
        status: "Available"
      )
    end

    redirect_to donated_item_request_path(@donated_item_request),
                notice: "Donated item request was declined.",
                status: :see_other
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donated_item_request
      @donated_item_request = DonatedItemRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
   def donated_item_request_params
      params.require(:donated_item_request).permit(
        :donated_item_id,
        :purpose,
        :recipient_name,
        :recipient_phone,
        :delivery_method,
        :delivery_email,
        :delivery_name,
        :delivery_address,
        :date_needed_by,
        :admin_notes
      )
  end
end
