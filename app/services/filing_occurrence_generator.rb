# app/services/filing_occurrence_generator.rb
class FilingOccurrenceGenerator
  def self.generate_from_start(filing, months_ahead: 12)
    new(filing).generate_from_start(months_ahead:)
  end

  def self.generate_next_year(filing, months_ahead: 12)
    new(filing).generate_from_next(months_ahead:)
  end

  def initialize(filing)
    @filing = filing
  end

  def generate_from_start(months_ahead:)
    start_date = filing.start_date
    generate_from_date(start_date, months_ahead:)
  end

  def generate_from_next(months_ahead:)
    start_date =
      filing.filing_occurrences.maximum(:due_date)&.+(1.day) ||
      filing.start_date

    generate_from_date(start_date, months_ahead:)
  end

  private

  attr_reader :filing

  def generate_from_date(start_date, months_ahead:)
    if filing.frequency.to_s.downcase.in?(%w[annual annually])
      generate_single_annual(start_date)
      return
    end
  
    end_date = start_date.advance(months: months_ahead)
  
    due_dates_between(start_date, end_date).each do |due_date|
      next if due_date.blank?
  
      FilingOccurrence.find_or_create_by!(
        filing: filing,
        due_date: due_date
      ) do |occurrence|
        occurrence.generated = true
        occurrence.cost = filing.cost
      end
    end
  end
  

  def due_dates_between(start_date, end_date)
    case filing.frequency.to_s.downcase
    when "monthly"
      monthly_dates(start_date, end_date)
    when "quarterly"
      quarterly_dates(start_date, end_date)
    when "annual", "annually"
      annual_dates(start_date, end_date)
    else
      []
    end
  end

  def monthly_dates(start_date, end_date)
    dates = []
    date = align_to_day(start_date)

    while date && date <= end_date
      dates << date
      date = date.advance(months: 1)
    end

    dates
  end

  def quarterly_dates(start_date, end_date)
    dates = []
    date = align_to_day(start_date)

    while date && date <= end_date
      dates << date
      date = date.advance(months: 3)
    end

    dates
  end

  def annual_dates(start_date, end_date)
    dates = []
  
    year = start_date.year
  
    loop do
      date = Date.new(year, filing.month_of_year, filing.day_of_month)
  
      # if this year's date already passed, jump to next year
      date = date.next_year if date < start_date
  
      break if date > end_date
  
      dates << date
      year = date.year + 1
    end
  
    dates
  rescue Date::Error
    []
  end
  

  def align_to_day(date)
    Date.new(date.year, date.month, filing.day_of_month)
  rescue Date::Error
    nil
  end

  def generate_single_annual(start_date)
    year = start_date.year
    date = Date.new(year, filing.month_of_year, filing.day_of_month)
  
    date = date.next_year if date < start_date
  
    FilingOccurrence.find_or_create_by!(
      filing: filing,
      due_date: date
    ) do |occurrence|
      occurrence.generated = true
      occurrence.cost = filing.cost
    end
  rescue Date::Error
    nil
  end
end

