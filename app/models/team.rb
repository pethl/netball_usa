class Team < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :member_key_roles, dependent: :destroy
  
  belongs_to(
    :creator,
    class_name: 'User',
    foreign_key: 'user_id',
    inverse_of: :teams
  )
  validates :name, presence: true
  validates :city, presence: true
  validates :state, presence: true
 
  
  scope :ordered, -> { order(name: :asc) }
  
  def region_name
    Region.where(state: self.state).first.region
  end
  
  def members?
    members.any?
  end
  
  def team_president
    @member_key_role = MemberKeyRole.where(team_id: self.id, key_role: "Team President").first
    if @member_key_role.blank?
       "Please nominate"
     else
    @member = Member.find(@member_key_role.member_id)
    @member.full_name
  end
  end
  
  def head_coach
    @member_key_role = MemberKeyRole.where(team_id: self.id, key_role: "Head Coach").first
    if @member_key_role.blank?
       "Please nominate"
     else
    @member = Member.find(@member_key_role.member_id)
    @member.full_name
  end
  end
  
  def head_umpire
    @member_key_role = MemberKeyRole.where(team_id: self.id, key_role: "Head Umpire").first
    if @member_key_role.blank?
       "Please nominate"
     else
    @member = Member.find(@member_key_role.member_id)
    @member.full_name
  end
  end
end
