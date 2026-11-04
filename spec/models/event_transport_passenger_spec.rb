require "rails_helper"

RSpec.describe EventTransportPassenger, type: :model do
  it "falls back to the registered person's phone" do
    person = create(:person, phone: "555-1000")
    passenger = build(:event_transport_passenger, person: person, phone: nil)

    expect(passenger.display_phone).to eq("555-1000")
  end

  it "allows a journey-specific phone override" do
    person = create(:person, phone: "555-1000")
    passenger = build(:event_transport_passenger, person: person, phone: "555-2000")

    expect(passenger.display_phone).to eq("555-2000")
  end

  it "requires either a registered person or a write-in name" do
    passenger = build(:event_transport_passenger, person: nil, write_in_name: nil)

    expect(passenger).not_to be_valid
  end
end
