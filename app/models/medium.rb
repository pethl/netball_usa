class Medium < ApplicationRecord

  validates :media_type, presence: true
  validates :company_name, presence: true

  scope :ordered, -> { order(company_name: :asc) }
end
