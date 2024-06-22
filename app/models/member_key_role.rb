class MemberKeyRole < ApplicationRecord
  belongs_to :na_team

   validates :key_role, presence: true
   validates :member_id, presence: true
   validates :na_team_id, presence: true
   validates_uniqueness_of :na_team_id, scope: :key_role 
 
   scope :ordered, -> { order(key_role: :desc) }
   
  
end
