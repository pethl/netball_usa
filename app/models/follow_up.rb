class FollowUp < ApplicationRecord
   belongs_to :user, optional: true # allows user_id to be blank temporarily
   belongs_to :event, optional: true
   belongs_to :netball_educator, optional: true

   
   #validates :user, presence: { message: "must be assigned to a user" }
   validates :netball_educator, presence: { message: "must be linked " }

  
end
