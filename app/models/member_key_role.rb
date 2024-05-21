class MemberKeyRole < ApplicationRecord
  belongs_to :team

  
   validates :key_role, presence: true
   validates :member_id, presence: true
   validates :team_id, presence: true
 validates_uniqueness_of :team_id, scope: :key_role 
#   validate :limit_key_roles
   
   
   scope :ordered, -> { order(key_role: :desc) }
   
   
   
 #  def limit_key_roles
 #       errors.add(:base, "Key role already filled for this team") and return unless (MemberKeyRole.find(team_id: self.team_id, member_id: self.id))
 #       end
   
end
