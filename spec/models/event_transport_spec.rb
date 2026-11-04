require "rails_helper"

RSpec.describe EventTransport, type: :model do
  it "is valid with journey details" do
    expect(build(:event_transport)).to be_valid
  end

  it "requires an arrival time after departure when supplied" do
    transport = build(:event_transport, arrival_at: Time.zone.parse("2026-11-06 10:00"))

    expect(transport).not_to be_valid
    expect(transport.errors[:arrival_at]).to include("must be after the departure time")
  end

  it "supports registered and write-in passengers" do
    transport = create(:event_transport)
    registered = create(:event_transport_passenger, event_transport: transport)
    write_in = create(:event_transport_passenger,
                      event_transport: transport,
                      person: nil,
                      write_in_name: "Local Volunteer",
                      phone: "555-0100")

    expect(registered.display_name).to eq(registered.person.full_name)
    expect(write_in.display_name).to eq("Local Volunteer")
  end
end
