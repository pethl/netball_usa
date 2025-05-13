class EventParticipant < ApplicationRecord

  belongs_to :event
  belongs_to :person, optional: true  # If a person can be associated
  belongs_to :netball_educator, optional: true  # If a netball educator can be associated

  # Ensure only one of person or netball_educator is present at a time
  #validates :person_id, presence: true, unless: :netball_educator_id
  #validates :netball_educator_id, presence: true, unless: :person_id


  #REMOVED THIS DUE TO SITUATION CAN NEVER ARISE AND CAN CAUSE BUGS
  #validate :only_one_participant_type_present

  # def only_one_participant_type_present
  #   if person_id.blank? && netball_educator_id.blank?
  #     errors.add(:base, "Either person or netball educator must be present")
  #   elsif person_id.present? && netball_educator_id.present?
  #     errors.add(:base, "Only one of person or netball educator can be present")
  #   end
  # end
end
