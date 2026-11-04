class EventTransportPassenger < ApplicationRecord
  belongs_to :event_transport
  belongs_to :person, optional: true

  validates :person_id,
            uniqueness: { scope: :event_transport_id },
            allow_nil: true
  validate :registered_or_write_in_name

  def display_name
    person&.full_name.presence || write_in_name
  end

  def display_phone
    phone.presence || person&.phone
  end

  private

  def registered_or_write_in_name
    if person_id.present? && write_in_name.present?
      errors.add(:base, "Choose a registered person or enter a write-in name, not both")
    elsif person_id.blank? && write_in_name.blank?
      errors.add(:base, "A registered person or write-in name is required")
    end
  end
end
