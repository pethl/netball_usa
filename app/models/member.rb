class Member < ApplicationRecord
  belongs_to :na_team
   
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
  
 
  
  

  scope :ordered, -> { order(first_name: :asc) }
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end
  
  # def is_key_role
  #   if MemberKeyRole.where(na_team_id: self.na_team_id, member_id: self.id).count>0
  #     return true
  #   else false
  #   end
  # end
 
end
