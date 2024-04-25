class Team < ApplicationRecord
  has_many :members, dependent: :destroy
  
  belongs_to(
    :creator,
    class_name: 'User',
    foreign_key: 'user_id',
    inverse_of: :teams
  )
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  
  scope :ordered, -> { order(name: :asc) }
  
  def region_name
    Region.where(state: self.state).first.region
  end
end
