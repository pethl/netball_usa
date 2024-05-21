class Member < ApplicationRecord
  belongs_to :team
   
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true

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
