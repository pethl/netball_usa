class UniversityObjective < ApplicationRecord
  validates :title, presence: true
  validates :timeframe, presence: true
  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validate :timeframe_must_be_active_reference

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :title) }
  scope :short_term, -> { where(timeframe: "Short Term") }
  scope :long_term, -> { where(timeframe: "Long Term") }

  private

  def timeframe_must_be_active_reference
    return if timeframe.blank?

    valid_timeframes = Reference.where(
      group: "university_objective_timeframe",
      active: true
    ).pluck(:value)

    return if timeframe.in?(valid_timeframes)

    errors.add(:timeframe, "is not a valid active objective timeframe")
  end
end