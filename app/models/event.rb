class Event < ApplicationRecord
    has_many :event_participants, dependent: :destroy
    has_many :people, through: :event_participants
    
     validates :event_type, presence: true
      validates :name, presence: true
  
end
