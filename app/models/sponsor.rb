class Sponsor < ApplicationRecord
  belongs_to :user
  has_many :opportunities, dependent: :destroy
  has_many :contacts
  
  validates :company_name, presence: true
  validates :industry, presence: true
  validates :sponsor_category, presence: true
  
  scope :ordered, -> { order(company_name: :asc) }

 
  def city_state
    self.city + " " + self.state
  end

  #DUP TO TOUR PARTNET
    def address_condensed
        if self.location.to_s.blank? && self.city.to_s.blank? && self.state.to_s.blank?
            return ""
        elsif self.location.to_s.blank? && self.city.to_s.blank?
           return "#{self.state}"
    
        elsif self.location.to_s.blank? && self.state.to_s.blank?
            "#{self.city}"
        
        elsif self.city.to_s.blank? && self.state.to_s.blank?
            "#{self.location}"
    
        elsif self.location.to_s.blank? 
            "#{self.city}, #{self.state}"
        
        elsif self.city.to_s.blank? 
            "#{self.location}, #{self.state}"
           
        elsif self.state.to_s.blank? 
            "#{self.location}, #{self.city}"
        
        else
            "#{self.location}, #{self.city}, #{self.state}"
        end
    end
end
