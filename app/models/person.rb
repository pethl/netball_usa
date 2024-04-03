class Person < ApplicationRecord
  include ImageUploader::Attachment(:image) 
  has_many :event_participants, dependent: :destroy
  has_many :events, through: :event_participants

 
  validates :role, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def role_full_name
    "#{self.role} - #{self.last_name}, #{self.first_name}"
  end
end
