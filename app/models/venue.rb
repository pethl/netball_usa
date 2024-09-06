class Venue < ApplicationRecord
    validates :facility_type, presence: true

    
    #DUP-ISH TO SPONSOR PARTNER TOUR
    def address_condensed
        if self.street.to_s.blank? && self.city.to_s.blank? && self.state.to_s.blank?
            return ""
        elsif self.street.to_s.blank? && self.city.to_s.blank?
        return "#{self.state}"

        elsif self.street.to_s.blank? && self.state.to_s.blank?
            "#{self.city}"
        
        elsif self.city.to_s.blank? && self.state.to_s.blank?
            "#{self.street}"

        elsif self.street.to_s.blank? 
            "#{self.city}, #{self.state}"
        
        elsif self.city.to_s.blank? 
            "#{self.street}, #{self.state}"
        
        elsif self.state.to_s.blank? 
            "#{self.street}, #{self.city}"
        
        else
            "#{self.street}, #{self.city}, #{self.state}"
        end
    end
end
