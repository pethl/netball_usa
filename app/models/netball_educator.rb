class NetballEducator < ApplicationRecord
  belongs_to :user, optional: true
  has_many :equipment
  has_many :follow_ups
  # 1. Events where this educator is *participating* (many-to-many via join)
  has_many :event_participants, dependent: :destroy 
  has_many :events, through: :event_participants
   # 2. Events where this educator is the *key PE Director contact* (one-to-many direct)
  has_many :key_events, class_name: "Event", foreign_key: :key_pe_director_id
 
  before_save { email.downcase! }
  before_save :normalize_phone
  
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
#  validates :phone, phone: true, allow_blank: true
  validates :school_name, presence: true, length: { maximum: 100 }
  validates :city, presence: true, length: { maximum: 50 }, on: :create
  validates :state, presence: true
  validates :level, presence: true, on: :create, unless: -> { role == "Kidokinetics" }


    # Scope: Only PE Directors, sorted by state, then last_name
    scope :pe_directors_by_state, -> {
      where(is_pe_director: true).order(:state, :last_name, :first_name)
    }
    scope :excluding_kidos, -> { where.not(role: "Kidokinetics") }

     # Method: Display format "STATE - Lastname, Firstname"
  def state_name_display
    "#{state} - #{last_name}, #{first_name}"
  end 
                     
 
  def follow_up
    FollowUp.where(netball_educator_id: self.id)
  end
  
  def equipment
    Equipment.where(netball_educator_id: self.id)
  end
  
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
    
    def reverse_name_school_state
      "#{self.last_name}, #{self.first_name} : #{self.school_name}, #{self.state}"
    end
    
    def reverse_name
      "#{self.last_name}, #{self.first_name} "
    end
    
    def full_name_school_state
      "#{self.first_name} #{self.last_name} : #{self.school_name}, #{self.state}"
    end
    
    def school_and_location
      "#{self.school_name}, #{self.city}, #{self.state}"
    end
    
    def contact_details
      "#{self.email}, #{self.phone}"
    end
 
  private
 
  def normalize_phone
      self.phone = Phonelib.parse(phone).full_e164.presence
    end
end
