class Filing < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_many :filing_occurrences, dependent: :destroy

  before_validation :set_created_by, on: :create
  before_save :sync_paused_at
  
  validates :corporate_name, :frequency, presence: true
  
  validates :day_of_month, presence: true, if: -> { frequency == "Monthly" }
  with_options if: -> { frequency == "monthly" } do
    validates :day_of_month, presence: true
    validates :month_of_year, absence: true
  end
  
  with_options if: -> { frequency == "annual" } do
    validates :day_of_month, presence: true
    validates :month_of_year, presence: true
  end

  scope :ordered_by_corporate_name, -> { order(:corporate_name) }
  scope :unfiled, -> { where(filed: false) }

  def last_occurrence_date
    filing_occurrences.maximum(:due_date)
  end
  
  private

  def set_created_by
    self.created_by ||= Current.user
  end

  def sync_paused_at
    return unless will_save_change_to_active?

    if active == false
      self.paused_at ||= Date.current
    else
      self.paused_at = nil
    end
  end

end
