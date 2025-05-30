class Region < ApplicationRecord
  # Scopes
  scope :ordered, -> { order(region: :desc) }

  # Validations
  validates :state, uniqueness: { message: "is already assigned to a region" }

  # Returns all state codes for this region
  def states_in_region
    Region.where(region: self.region).pluck(:state)
  end

  # Returns all clubs that belong to states in this region
  def clubs_in_region
    Club.where(us_state: states_in_region)
  end
end 
