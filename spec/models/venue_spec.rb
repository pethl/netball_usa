require 'rails_helper'

RSpec.describe Venue, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      expect(build(:venue)).to be_valid
    end

    it "is not valid without a facility_type" do
      venue = build(:venue, facility_type: nil)
      expect(venue).not_to be_valid
      expect(venue.errors[:facility_type]).to include("can't be blank")
    end
  end

  describe "#address_condensed" do
    it "returns full address when all fields are present" do
      venue = build(:venue, street: "123 Main St", city: "Miami", state: "FL")
      expect(venue.address_condensed).to eq("123 Main St, Miami, FL")
    end

    it "handles missing street" do
      venue = build(:venue, street: nil, city: "Miami", state: "FL")
      expect(venue.address_condensed).to eq("Miami, FL")
    end

    it "handles missing city" do
      venue = build(:venue, street: "123 Main St", city: nil, state: "FL")
      expect(venue.address_condensed).to eq("123 Main St, FL")
    end

    it "handles missing state" do
      venue = build(:venue, street: "123 Main St", city: "Miami", state: nil)
      expect(venue.address_condensed).to eq("123 Main St, Miami")
    end

    it "returns blank string if all are missing" do
      venue = build(:venue, street: nil, city: nil, state: nil)
      expect(venue.address_condensed).to eq("")
    end
  end
end

