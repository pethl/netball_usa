class FilingsController < ApplicationController
  before_action :set_filing, only: %i[ show edit update destroy ]
  load_and_authorize_resource

  # GET /filings
  def index
    @calendar_year = params[:year]&.to_i || Date.current.year
    @prev_year = @calendar_year - 1
    @next_year = @calendar_year + 1
    @current_month = Date.current.month


    year = params[:year]&.to_i || Date.current.year
    year_range = Date.new(year,1,1)..Date.new(year,12,31)
    
    @occurrences_by_month =
  FilingOccurrence
    .joins(:filing)
    .includes(:filing)
    .where(due_date: year_range)
    .where(
      "filings.active = TRUE
       OR filing_occurrences.due_date < filings.paused_at"
    )
    .order(:due_date)
    .group_by { |o| o.due_date.month }

    
    @monthly_totals =
      @occurrences_by_month.transform_values do |occurrences|
        occurrences.sum { |o| o.filing.cost.to_f }
      end

      @yearly_total =
    @monthly_totals.values.sum
      
    @filings = Filing.ordered_by_corporate_name

    @filings = @filings.where(frequency: params[:frequency]) if params[:frequency].present?
    @filings = @filings.where("corporate_name ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    
    if params[:active].present?
      @filings = @filings.where(active: ActiveModel::Type::Boolean.new.cast(params[:active]))
    end
  end

  # GET /filings/1
  def show
    @filing = Filing.find(params[:id])

    @occurrences = @filing.filing_occurrences.order(:due_date)
  end

  # GET /filings/new
  def new
    @filing = Filing.new(start_date: Date.current)
  end

  # GET /filings/1/edit
  def edit
  end

  # POST /filings
  def create
    @filing = Filing.new(filing_params)
    @filing.created_by = current_user
  
    if @filing.save
      FilingOccurrenceGenerator.generate_from_start(
        @filing,
        months_ahead: 12
      )
  
      redirect_to @filing, notice: "Filing was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  # PATCH/PUT /filings/1
  def update
    if @filing.update(filing_params)
      if params[:update_future_costs] == "1"
        update_future_occurrence_costs(@filing)
      end
  
      redirect_to @filing, notice: "Filing was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  

  # DELETE /filings/1
  def destroy
    @filing.destroy
    redirect_to filings_url, notice: "Filing was successfully destroyed.", status: :see_other
  end


  def generate_next_year
    filing = Filing.find(params[:id])
  
    FilingOccurrenceGenerator.generate_next_year(filing)
  
    redirect_to filing_path(filing),
      notice: "Next year of payments due generated"
  end

  private

  def set_filing
    @filing = Filing.find(params[:id])
  end

  def filing_params
    params.require(:filing).permit(
      :corporate_name,
    :filing_type,
    :frequency,
    :day_of_month,
    :month_of_year,
    :start_date,
    :paused_at,
    :cost,
    :website,
    :site_user_id,
    :site_password,
    :site_email,
    :active,
    :notes

    )
  end

  def update_future_occurrence_costs(filing)
    filing.filing_occurrences
      .where(filed: false)
      .where("due_date >= ?", Date.current)
      .update_all(cost: filing.cost)
  end
end
