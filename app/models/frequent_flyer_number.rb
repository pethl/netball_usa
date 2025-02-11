class FrequentFlyerNumber < ApplicationRecord
  belongs_to :person
  # Validate presence of airline and number, but allow them to be blank individually
  validates :airline, presence: true, if: -> { number.present? }
  validates :number, presence: true, if: -> { airline.present? }

  # Custom validation to discard FFN if both airline and number are blank
  before_validation :discard_empty_ffn, on: :create

  private

  # If both airline and number are blank, mark this FFN for deletion
  def discard_empty_ffn
    if airline.blank? && number.blank?
      throw(:abort)  # This will prevent this FFN from being saved
    end
  end
end
