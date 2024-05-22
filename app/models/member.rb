class Member < ApplicationRecord
  belongs_to :team
   
  validates :first_name, presence: true
  validates :last_name, presence: true
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  

  scope :ordered, -> { order(first_name: :asc) }
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def is_key_role
    if MemberKeyRole.where(team_id: self.team_id, member_id: self.id).count>0
      return true
    else false
    end
  end
 
end
