class MemberKeyRole < ApplicationRecord
  belongs_to :club

   validates :key_role, presence: true
   validates :member_id, presence: true
   validates :club_id, presence: true
   validates_uniqueness_of :club_id, scope: :key_role 
 
   scope :ordered, -> { order(key_role: :desc) }
   
  
end
