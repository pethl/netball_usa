require 'rails_helper'

RSpec.describe Grant, type: :model do
  let(:user) { create(:user) }
  subject { build(:grant, user: user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a name" do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a status" do
      subject.status = nil
      expect(subject).not_to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end

