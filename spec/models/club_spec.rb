require 'rails_helper'

RSpec.describe Club, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:us_state) }
    it { should validate_presence_of(:membership_category).on(:create) }
    it { should validate_presence_of(:estimate_total_number_of_club_members).on(:create) }
    it { should validate_presence_of(:estimate_total_active_members).on(:create) }
   # it { should validate_presence_of(:estimate_total_part_time_members).on(:create) }
  end

  describe "associations" do
    it { should have_many(:members).dependent(:destroy) }
    it { should have_many(:member_key_roles).dependent(:destroy) }
    it { should have_many(:individual_members) }
    it { should have_many(:payments) }
    it { should have_many(:teams) }
    it { should have_many(:notes).dependent(:destroy) }
    it { should belong_to(:creator).class_name('User') }
  end

  describe "methods" do
    let(:club) { create(:club) }

    it "returns 'Payment Due' if no payments" do
      expect(club.has_paid).to eq("Payment Due")
    end

    it "correctly detects renewed year" do
      club.update(renewal_years: "2023,2024")
      expect(club.renewed_for_year?(2024)).to be true
      expect(club.renewed_for_year?(2025)).to be false
    end

    it "correctly totals members" do
      create(:member, club: club)
      create(:individual_member, club: club)
      expect(club.club_total_members).to eq(2)
    end
  end

  describe "callbacks" do
    it "titleizes name and city on create" do
      club = create(:club, name: "my club", city: "big city")
      expect(club.name).to eq("My Club")
      expect(club.city).to eq("Big City")
    end

    it "defaults estimate_total_part_time_members to 0 if nil" do
      club = create(:club, estimate_total_part_time_members: nil)
      expect(club.estimate_total_part_time_members).to eq(0)
    end
  end
end

