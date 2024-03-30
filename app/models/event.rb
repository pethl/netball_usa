class Event < ApplicationRecord
    has_many :event_participants, dependent: :destroy
    has_many :people, through: :event_participants
    belongs_to :budget, optional: true 
    
    validates :event_type, presence: true
    validates :name, presence: true
  
  
    def budget
      Budget.where(event_id: self.id).first
      
    end
end
