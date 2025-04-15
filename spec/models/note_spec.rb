require 'rails_helper'

RSpec.describe Note, type: :model do
  let(:club) { create(:club) }
  subject { build(:note, club: club) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a club" do
      subject.club = nil
      expect(subject).not_to be_valid
    end

    # Optional: test if you want to require a body or status
    it "can have a blank body" do
      subject.body = nil
      expect(subject).to be_valid
    end

    it "can have a blank status" do
      subject.status = nil
      expect(subject).to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:club) }
  end
end

