class UniversityTask < ApplicationRecord
  belongs_to :university_objective

  validates :category, presence: true
  validates :action, presence: true
  validates :status, presence: true

  validates :position,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  validate :category_must_be_active_reference
  validate :status_must_be_active_reference

  scope :ordered, -> { order(:position, :due_date, :created_at) }

  private

  def category_must_be_active_reference
    return if category.blank?

    valid_categories = Reference.where(
      group: "university_task_category",
      active: true
    ).pluck(:value)

    return if category.in?(valid_categories)

    errors.add(:category, "is not a valid active task category")
  end

  def status_must_be_active_reference
    return if status.blank?

    valid_statuses = Reference.where(
      group: "university_task_status",
      active: true
    ).pluck(:value)

    return if status.in?(valid_statuses)

    errors.add(:status, "is not a valid active task status")
  end
end