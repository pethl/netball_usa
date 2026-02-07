class FilingOccurrencesController < ApplicationController
  before_action :set_occurrence

  def update
    @occurrence.update(occurrence_params)
    redirect_back fallback_location: filing_path(@occurrence.filing)
  end

  private

  def set_occurrence
    @occurrence = FilingOccurrence.find(params[:id])
  end

  def occurrence_params
    params.require(:filing_occurrence).permit(
      :filed,
      :cost,
      :filed_at
    )
  end
end

