class Venue < ApplicationRecord
    validates :facility_type, presence: true
end
