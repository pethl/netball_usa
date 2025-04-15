class Partner < ApplicationRecord
    has_many :contacts
   # has_one :person - not sure what this was doe
    belongs_to :user

    validates :company, presence: { message: ": Please enter name before attempting to save" }
    scope :ordered, -> { order(company: :asc) }

    def contact_two_blank
        if (first_name_secondary.to_s +
            last_name_secondary.to_s +
            role_secondary.to_s +
            email_secondary.to_s +
            cell_secondary.to_s +
            work_phone_secondary.to_s).empty?
            false
        else
            true
        end
    end

    def contact_three_blank
        if (first_name_third.to_s +
            last_name_third.to_s +
            role_third.to_s +
            email_third.to_s +
            cell_third.to_s +
            work_phone_third.to_s).empty?
            false
        else
            true
        end
    end

    def address_condensed
        if self.location.to_s.blank? && self.city.to_s.blank? && self.us_state.to_s.blank?
            return ""
        elsif self.location.to_s.blank? && self.city.to_s.blank?
           return "#{self.us_state} #{country}"
    
        elsif self.location.to_s.blank? && self.us_state.to_s.blank?
            "#{self.city} #{country}"
        
        elsif self.city.to_s.blank? && self.us_state.to_s.blank?
            "#{self.location} #{country}"
    
        elsif self.location.to_s.blank? 
            "#{self.city}, #{self.us_state}  #{country}"
        
        elsif self.city.to_s.blank? 
            "#{self.location}, #{self.us_state} #{country}"
           
        elsif self.us_state.to_s.blank? 
            "#{self.location}, #{self.city} #{country}"
        
        else
            "#{self.location}, #{self.city}, #{self.us_state} #{country}"
        end
    end
end
