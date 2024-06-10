class ReferencesController < ApplicationController
  before_action :set_reference, only: %i[ show edit update destroy ]

  # GET /references
  def index
    authorize! :read, @references
    @references = Reference.all.order(group: :asc)
    @references_by_group = @references.group_by { |t| t.group }
  end

  # GET /references/1
  def show
  end

  # GET /references/new
  def new
    @reference = Reference.new
  end

  # GET /references/1/edit
  def edit
    @reference= set_reference
  end

  # POST /references
  def create
    @reference = Reference.new(reference_params)

    if @reference.save
      redirect_to @reference, notice: "Reference was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /references/1
  def update
    if @reference.update(reference_params)
      redirect_to @reference, notice: "Reference was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /references/1
  def destroy
    @reference.destroy
    redirect_to references_url, notice: "Reference was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reference
      @reference = Reference.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reference_params
      params.require(:reference).permit(:group, :value, :key, :desc, :active)
    end
end
