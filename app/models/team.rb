class Team < ApplicationRecord
  belongs_to :club, optional: true
  has_many :members
  
  validates :name, presence: true
  
  scope :ordered, -> { order(id: :asc) }
  #scope :ordered, -> { order(name: :asc) }
  
  #def region_name
  #  Region.where(state: self.state).first.region
  #end
  
  #def members?
  #  members.any?
  #end
  
end
