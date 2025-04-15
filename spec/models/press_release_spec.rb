require 'rails_helper'

RSpec.describe PressRelease, type: :model do
  let(:medium) { create(:medium) }
  subject { build(:press_release, medium: medium) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a medium" do
      subject.medium = nil
      expect(subject).not_to be_valid
    end

    it "is valid without a release_date if no link is present" do
      subject.media_announcement_link = nil
      subject.release_date = nil
      expect(subject).to be_valid
    end

    it "is valid without a media_announcement_link and with a release_date" do
      subject.media_announcement_link = nil
      subject.release_date = Date.today
      expect(subject).to be_valid
    end

    it "is not valid with a media_announcement_link and no release_date" do
      subject.media_announcement_link = "https://example.com"
      subject.release_date = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:release_date]).to include("must be provided if you add a media announcement link.")
    end
  end

  describe "associations" do
    it { should belong_to(:medium) }
  end
end

