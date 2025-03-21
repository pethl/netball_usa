class VendorsController < ApplicationController
  before_action :set_vendor, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /vendors
  def index
    @vendors = Vendor.all
  end

  # GET /vendors/1
  def show
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors
  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      redirect_to @vendor, notice: "Vendor was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /vendors/1
  def update
    if @vendor.update(vendor_params)
      redirect_to @vendor, notice: "Vendor was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /vendors/1
  def destroy
    @vendor.destroy!
    redirect_to vendors_url, notice: "Vendor was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      params.require(:vendor).permit(:company_name, :contact_name, :email, :phone, :website, :notes, reference_ids: [])
    end
end
