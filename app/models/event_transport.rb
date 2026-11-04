class EventTransport < ApplicationRecord
  belongs_to :transfer_event, class_name: "Event"

  has_many :event_transport_passengers, dependent: :destroy
  has_many :people, through: :event_transport_passengers

  accepts_nested_attributes_for :event_transport_passengers,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :departure_at, :pickup_location, :destination, presence: true
  validate :arrival_must_follow_departure

  scope :scheduled, -> { order(:departure_at) }

  def registered_passengers
    event_transport_passengers.where.not(person_id: nil)
  end

  def write_in_passengers
    event_transport_passengers.where(person_id: nil)
  end

  private

  def arrival_must_follow_departure
    return if arrival_at.blank? || departure_at.blank? || arrival_at >= departure_at

    errors.add(:arrival_at, "must be after the departure time")
  end
end
