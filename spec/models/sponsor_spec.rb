require 'rails_helper'

RSpec.describe Sponsor, type: :model do
  let(:user) { create(:user) }

  subject { build(:sponsor, user: user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a company_name" do
      subject.company_name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an industry" do
      subject.industry = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a sponsor_category" do
      subject.sponsor_category = nil
      expect(subject).to_not be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:opportunities).dependent(:destroy) }
    it { should have_many(:contacts) }
  end

  describe "scopes" do
    it "orders by company_name ascending" do
      # Remove conflicting records with same names if necessary (optional)
      Sponsor.where(company_name: ["Alpha Co", "Beta Co"]).destroy_all
  
      s1 = create(:sponsor, company_name: "Beta Co", user: user)
      s2 = create(:sponsor, company_name: "Alpha Co", user: user)
  
      ordered = Sponsor.ordered.where(id: [s1.id, s2.id])
      expect(ordered).to eq([s2, s1])
    end

  end

  describe "#city_state" do
    it "returns city and state combined" do
      sponsor = build(:sponsor, city: "Dallas", state: "TX")
      expect(sponsor.city_state).to eq("Dallas TX")
    end
  end

  describe "#address_condensed" do
    it "returns full address when all fields are present" do
      sponsor = build(:sponsor, location: "Suite 100", city: "New York", state: "NY")
      expect(sponsor.address_condensed).to eq("Suite 100, New York, NY")
    end

    it "handles missing location" do
      sponsor = build(:sponsor, location: nil, city: "Phoenix", state: "AZ")
      expect(sponsor.address_condensed).to eq("Phoenix, AZ")
    end

    it "returns empty string when all parts are blank" do
      sponsor = build(:sponsor, location: nil, city: nil, state: nil)
      expect(sponsor.address_condensed).to eq("")
    end
  end
end

