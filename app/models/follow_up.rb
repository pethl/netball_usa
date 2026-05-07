class FollowUp < ApplicationRecord
   belongs_to :user, optional: true # allows user_id to be blank temporarily
   belongs_to :event, optional: true
   belongs_to :netball_educator, optional: true

   validates :lead_type, presence: { message: "must be selected" }
   #validates :user, presence: { message: "must be assigned to a user" }
   #not currenty enforced - becuase small user group can be trusted to add after creation
   #validates :netball_educator, presence: { message: "must be linked " }
   #
   scope :talentlockr, -> {
      where(
         "follow_ups.netball_educator_id IN (
            SELECT netball_educators.id::text
            FROM netball_educators
            WHERE netball_educators.partner_group = ?
         )",
         "Talentlockr"
      )
      }

      scope :excluding_talentlockr, -> {
      where(
         "follow_ups.netball_educator_id IS NULL
         OR follow_ups.netball_educator_id NOT IN (
            SELECT netball_educators.id::text
            FROM netball_educators
            WHERE netball_educators.partner_group = ?
         )",
         "Talentlockr"
      )
      }
      
end
