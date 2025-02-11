class Person < ApplicationRecord
include ImageUploader::Attachment(:image) 
include ImageUploader::Attachment(:headshot)   # ImageUploader will attach and manage `headshot`
include ImageUploader::Attachment(:certification)   # ImageUploader will attach and manage `certification`

  #has_many :transfers 
  has_many :event_participants, dependent: :destroy
  has_many :events, through: :event_participants
  #has_many :programs
  has_many :frequent_flyer_numbers, dependent: :destroy
  accepts_nested_attributes_for :frequent_flyer_numbers, allow_destroy: true

  scope :ordered, -> { order(first_name: :asc) }
  
  validates :role, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    allow_blank: true
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def role_full_name
    "#{self.role} - #{self.last_name}, #{self.first_name}"
  end
end
