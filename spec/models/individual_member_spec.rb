require 'rails_helper'

RSpec.describe IndividualMember, type: :model do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    # Add others only if you have validations in model later
  end

  describe "associations" do
    it { should belong_to(:user) } # ✅ required, NO optional
    it { should belong_to(:team).optional } # ✅ optional
    it { should belong_to(:club).optional } # ✅ optional
    it { should have_many(:payments) }
  end

  describe "methods" do
    let(:individual_member) { create(:individual_member, first_name: "Handy", last_name: "Man") }

    it "returns full name correctly" do
      expect(individual_member.full_name).to eq("Handy Man")
    end

    it "detects a new member this year" do
      expect(individual_member.new_member_this_year?).to be true
    end

    it "detects not a new member if created last year" do
      member = create(:individual_member, created_at: 1.year.ago)
      expect(member.new_member_this_year?).to be false
    end

    it "downcases email before saving" do
      member = create(:individual_member, email: "Handy.Man@Example.COM")
      expect(member.email).to eq("handy.man@example.com")
    end
  end

  describe "validations" do
    it "is invalid without state or country" do
      member = build(:individual_member, state: nil, country: nil)
      expect(member).to_not be_valid
      expect(member.errors[:base]).to include("Either state or country must be provided")
    end
  end
end