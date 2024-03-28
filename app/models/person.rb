class Person < ApplicationRecord
  has_many :event_participants, dependent: :destroy
  has_many :events, through: :event_participants
  
  
  validates :role, presence: true
 

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
