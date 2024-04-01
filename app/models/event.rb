class Event < ApplicationRecord
    has_many :event_participants, dependent: :destroy
    has_many :people, through: :event_participants
    belongs_to :budget, optional: true 
    
    validates :event_type, presence: true
    validates :name, presence: true
  
  
    def budget
      Budget.where(event_id: self.id).first
    end
    
    def event_date_name
     "#{self.event_date_formatted}, #{self.name} "
    end
    
    def event_date_formatted
      self.date.to_formatted_s(:usa) 
    end
end
