class EventParticipant < ApplicationRecord

  belongs_to :event
  belongs_to :person, optional: true  # If a person can be associated
  belongs_to :netball_educator, optional: true  # If a netball educator can be associated

  # Ensure only one of person or netball_educator is present at a time
  validates :person_id, presence: true, unless: :netball_educator_id
  validates :netball_educator_id, presence: true, unless: :person_id
end
