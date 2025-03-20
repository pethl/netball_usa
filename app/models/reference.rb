class Reference < ApplicationRecord
  has_many :reference_vendors
  has_many :vendors, through: :reference_vendors

  validates :group, presence: true
  validates :value, presence: true
    
  scope :ordered, -> { order(value: :asc) }
end
