class Budget < ApplicationRecord
  has_one :event
  
  def budget_total
    self.flight.to_f + self.hotel.to_f + self.transport.to_f + self.shipping.to_f + self.booth.to_f + self.carpet.to_f + self.banners.to_f + self.giveaways.to_f
  end
  
  def budget_event_name
    Event.find(self.event_id).name
  end
  
  def budget_event_date
    Event.find(self.event_id).date.to_formatted_s(:usa) 
  end
end
