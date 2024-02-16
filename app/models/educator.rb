class Educator < ApplicationRecord
  
  before_save { email.downcase! }
  validates :first_name, presence: true, length: { maximum: 30 }
  validates :last_name, presence: true, length: { maximum: 30 }
  validates :school_name, presence: true, length: { maximum: 40 }
  validates :city, presence: true, length: { maximum: 30 }
  validates :state, presence: true, length: { maximum: 30 }
                     
    
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  #validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

end
