class MemberKeyRole < ApplicationRecord
  belongs_to :club
  belongs_to :member 

  accepts_nested_attributes_for :member, update_only: true, reject_if: :reject_member_update

  def reject_member_update(attributes)
    attributes['id'].blank? # Only allow updates when member_id exists (i.e., editing an existing member)
  end

  validates :key_role, presence: true
  validates :member_id, presence: true
  validates :club_id, presence: true
  validates_uniqueness_of :club_id, scope: :key_role 

  scope :ordered, -> { order(key_role: :desc) }
   
end
