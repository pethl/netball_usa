require 'rails_helper'

RSpec.describe NetballEducator, type: :model do
  let(:user) { create(:user) }
  subject { build(:netball_educator, user: user) }

  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_most(30) }

    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should allow_value("test@example.com").for(:email) }
    it { should_not allow_value("bad_email").for(:email) }
    it "validates uniqueness of email (case-insensitive)" do
      create(:netball_educator, email: "duplicate@example.com")
      educator = build(:netball_educator, email: "DUPLICATE@example.com")
      expect(educator).not_to be_valid
    end

    it { should validate_presence_of(:school_name) }
    it { should validate_length_of(:school_name).is_at_most(100) }

    it { should validate_presence_of(:city) }
    it { should validate_length_of(:city).is_at_most(50) }

    it { should validate_presence_of(:state) }
  

    it { should validate_presence_of(:level) }
  end

  describe "associations" do
    it { should belong_to(:user).optional }
    it { should have_many(:equipment) }
    it { should have_many(:follow_ups) }
    it { should have_many(:event_participants) }
    it { should have_many(:events).through(:event_participants) }
  end

  describe "callbacks" do
    it "downcases the email before save" do
      subject.email = "UPPER@CASE.COM"
      subject.save!
      expect(subject.reload.email).to eq("upper@case.com")
    end

    it "normalizes the phone before save" do
      subject.phone = "(555) 555-5555"
      subject.save!
      expect(subject.reload.phone).to start_with("+1")
    end
  end

  describe "instance methods" do
    it "#full_name returns correct format" do
      expect(subject.full_name).to eq("Jane Doe")
    end

    it "#reverse_name returns correct format" do
      expect(subject.reverse_name).to eq("Doe, Jane ")
    end

    it "#school_and_location returns correct format" do
      expect(subject.school_and_location).to eq("Test Academy, Miami, FL")
    end

    it "#full_name_school_state returns correct format" do
      expect(subject.full_name_school_state).to eq("Jane Doe : Test Academy, FL")
    end

    it "#reverse_name_school_state returns correct format" do
      expect(subject.reverse_name_school_state).to eq("Doe, Jane : Test Academy, FL")
    end

    it "#contact_details returns correct format" do
      expect(subject.contact_details).to eq("#{subject.email}, #{subject.phone}")
    end

    it "#formatted_phone returns formatted version" do
      subject.phone = "415-555-1234"
      subject.save!
      expect(subject.formatted_phone).to match(/\(\d{3}\) \d{3}-\d{4}/).or match(/\+1\d+/)
    end
  end
end

