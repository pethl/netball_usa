class Budget < ApplicationRecord
  belongs_to :event
  
  validates :event, presence: true
  

  def per_diem_total
    self.per_diem.to_f * self.number_of_people.to_f * self.number_of_days.to_f
  end
 
  def budget_total
    self.flight.to_f + self.hotel.to_f + self.transport.to_f + self.shipping.to_f + self.booth.to_f + self.carpet.to_f + self.banners.to_f + self.giveaways.to_f + self.per_diem_total.to_f
  end
  
  def budget_event_name
    Event.find(self.event_id).name
  end
  
  def budget_event_date
    Event.find(self.event_id).date.to_formatted_s(:usa) 
  end
end
