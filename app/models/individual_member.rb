class IndividualMember < ApplicationRecord
    
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :city, presence: true
  validates :state, presence: true
  validates :gender, presence: true
  validates :age_status, presence: true
  validates :engagement_status, presence: true
  validates :membership_type, presence: true
  
  scope :ordered, -> { order(first_name: :asc) }
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
end