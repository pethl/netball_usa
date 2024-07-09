class Sponsor < ApplicationRecord
  belongs_to :user
  has_many :opportunities, dependent: :destroy
  has_many :contacts, dependent: :destroy
  
  validates :sponsor_category, presence: true
  validates :industry, presence: true
  validates :company_name, presence: true, length: { maximum: 40 }
  
  scope :ordered, -> { order(company_name: :asc) }
end
