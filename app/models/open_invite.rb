class OpenInvite < ApplicationRecord
  belongs_to :person, optional: true

  validates :person_id, presence: { message: ": Please select before attempting to save" }
end
