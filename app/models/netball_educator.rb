class NetballEducator < ApplicationRecord
  belongs_to :user, optional: true
 
  
  before_save { email.downcase! }
 before_save :normalize_phone
  
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: { maximum: 40 }
  validates :phone, phone: true, allow_blank: true
  validates :school_name, presence: true, length: { maximum: 40 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :state, presence: true, length: { maximum: 30 }
                     
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
 
  def formatted_phone
      parsed_phone = Phonelib.parse(phone)
      return phone if parsed_phone.invalid?

      formatted =
        if parsed_phone.country_code == "1" # NANP
          parsed_phone.full_national # (415) 555-2671;123
        else
          parsed_phone.full_international # +44 20 7183 8750
        end
      formatted.gsub!(";", " x") # (415) 555-2671 x123
      formatted
    end
 
    def full_name
      "#{self.first_name} #{self.last_name}"
    end
 
  private
 
  def normalize_phone
      self.phone = Phonelib.parse(phone).full_e164.presence
    end
end
