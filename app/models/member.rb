class Member < ApplicationRecord
  belongs_to :club
  belongs_to :team, optional: true
  
   
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :club_id, presence: true
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
  #validates :membership_type, presence: true
  
  scope :ordered, -> { order(first_name: :asc) }
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def club_name
    Club.find(self.club_id).name
  end
 
end
