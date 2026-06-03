class DonatedItemsController < ApplicationController
  before_action :set_donated_item, only: %i[ show edit update destroy ]

  # GET /donated_items
 # app/controllers/donated_items_controller.rb

def index
  @status = params[:status].presence || "Available"
  @search = params[:search].to_s.strip

  @statuses = Reference.where(active: true, group: "donated_items_status").pluck(:value)

  @donated_items = DonatedItem.all

  @donated_items = @donated_items.where(status: @status) if @status.present?

  if @search.present?
    @donated_items = @donated_items.where(
      "description ILIKE :search OR donor_name ILIKE :search OR item_type ILIKE :search",
      search: "%#{@search}%"
    )
  end

  @donated_items = @donated_items.order(created_at: :desc)
end

  # GET /donated_items/1
  def show
  end

  # GET /donated_items/new
  def new
    @donated_item = DonatedItem.new
  end

  # GET /donated_items/1/edit
  def edit
  end

  # POST /donated_items
  def create
    @donated_item = DonatedItem.new(donated_item_params)

    if @donated_item.save
      redirect_to @donated_item, notice: "Donated item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /donated_items/1
  def update
    if @donated_item.update(donated_item_params)
      redirect_to @donated_item, notice: "Donated item was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /donated_items/1
  def destroy
    @donated_item.destroy!
    redirect_to donated_items_url, notice: "Donated item was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donated_item
      @donated_item = DonatedItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def donated_item_params
      params.require(:donated_item).permit(:description, :item_type, :value, :requirements, :status, :expiry_date, :donor_name, :internal_notes)
    end
end
