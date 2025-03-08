class Medium < ApplicationRecord
  belongs_to :user

  validates :media_type, presence: true
  validates :company_name, presence: true

  scope :ordered, -> { order(company_name: :asc) }
end
