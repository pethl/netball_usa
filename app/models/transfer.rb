class Transfer < ApplicationRecord
  
  validates :role, presence: true
 
  def full_name
    "#{self.first_name} #{self.last_name}"
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
