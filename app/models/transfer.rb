class Transfer < ApplicationRecord
  include ImageUploader::Attachment(:headshot)   # ImageUploader will attach and manage `headshot`
  include ImageUploader::Attachment(:certification)   # ImageUploader will attach and manage `certification`

  has_one :event
  belongs_to :person, foreign_key: 'person_id'
  accepts_nested_attributes_for :person, update_only: true
  
  validates :person_id, presence: true
  validates :event_id, presence: true  
  validates_uniqueness_of :person_id 
  validates :role, presence: true
  #validates :check_in, allow_blank: true, comparison: { less_than: :check_out }
  #validates :check_out, allow_blank: true, comparison: { greater_than: :check_in }
  
  scope :ordered, -> { order(id: :asc) }
 
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def arrival_airline_and_terminal
    "#{self.arrival_airline} #{self.arrival_terminal}"
  end

  def departure_airline_and_terminal
    "#{self.departure_airline} #{self.departure_terminal}"
  end
  
  def arrival_date_only
     if !self.arrival_time.blank?
       self.arrival_time.to_formatted_s(:usa) 
     end
  end
  
  def departure_date_only
      if !self.departure_time.blank?
     self.departure_time.to_formatted_s(:usa) 
   end
    end
    
    def arrival_time_only_12_hour
       if !self.arrival_time.blank?
         self.arrival_time.to_formatted_s(:hour_clock_12) 
       end
    end
  
    def departure_time_only_12_hour
        if !self.departure_time.blank?
       self.departure_time.to_formatted_s(:hour_clock_12) 
     end
      end
end
