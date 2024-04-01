class FollowUp < ApplicationRecord
   belongs_to :user
   belongs_to :event, optional: true
   belongs_to :netball_educator, optional: true
end
