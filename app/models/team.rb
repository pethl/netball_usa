class Team < ApplicationRecord
  belongs_to :club, optional: true
  has_many :members
  has_many :individual_members
  
  validates :name, presence: true
  
  scope :ordered, -> { order(id: :asc) }
  
end
