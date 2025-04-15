require 'rails_helper'

RSpec.describe Member, type: :model do
  let(:club) { create(:club) }
  let(:member) { build(:member, club: club) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(member).to be_valid
    end

    it "is not valid without a first_name" do
      member.first_name = nil
      expect(member).to_not be_valid
    end

    it "is not valid without a last_name" do
      member.last_name = nil
      expect(member).to_not be_valid
    end

    it "is not valid without an email" do
      member.email = nil
      expect(member).to_not be_valid
    end

    it "is not valid with an improperly formatted email" do
      member.email = "bad_email"
      expect(member).to_not be_valid
    end

    it "is not valid without a city" do
      member.city = nil
      expect(member).to_not be_valid
    end

    it "is not valid without a state" do
      member.state = nil
      expect(member).to_not be_valid
    end

    it "is not valid without a gender" do
      member.gender = nil
      expect(member).to_not be_valid
    end

    it "is not valid without an age_status" do
      member.age_status = nil
      expect(member).to_not be_valid
    end

    it "is not valid without an engagement_status" do
      member.engagement_status = nil
      expect(member).to_not be_valid
    end

    it "is not valid without a club" do
      member.club = nil
      expect(member).to_not be_valid
    end

    it "is not valid with a duplicate email (case-insensitive)" do
      create(:member, email: "duplicate@example.com")
      member.email = "DUPLICATE@EXAMPLE.COM"
      expect(member).to_not be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:club) }
    it { should belong_to(:team).optional }
  end

  describe "#full_name" do
    it "returns the full name" do
      expect(member.full_name).to eq("#{member.first_name} #{member.last_name}")
    end
  end

  describe "#club_name" do
    it "returns the club name" do
      club = create(:club, name: "Sunset Club")
      member.club = club
      expect(member.club_name).to eq("Sunset Club")
    end
  end
end

