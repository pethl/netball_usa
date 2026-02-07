class FilingOccurrence < ApplicationRecord
  belongs_to :filing

  delegate :corporate_name, :filing_type, :frequency, to: :filing

  before_destroy :prevent_destroy_if_filed
  before_update  :prevent_due_date_change_if_filed

  private

  def prevent_destroy_if_filed
    return unless filed?
    errors.add(:base, "Filed occurrences cannot be deleted")
    throw :abort
  end

  def prevent_due_date_change_if_filed
    return unless filed? && will_save_change_to_due_date?
    errors.add(:due_date, "cannot be changed once filed")
    throw :abort
  end
end
