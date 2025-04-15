require 'rails_helper'

RSpec.describe Reference, type: :model do
  subject { build(:reference) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a group" do
      subject.group = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:group]).to include("can't be blank")
    end

    it "is not valid without a value" do
      subject.value = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:value]).to include("can't be blank")
    end
  end

  describe "associations" do
    it { should have_many(:reference_vendors) }
    it { should have_many(:vendors).through(:reference_vendors) }
  end

  describe "scopes" do
    it "orders by value ascending within the test data" do
      r1 = create(:reference, value: "Zebra", group: "test_group")
      r2 = create(:reference, value: "Alpha", group: "test_group")
  
      scoped = Reference.where(group: "test_group").ordered
      expect(scoped).to eq([r2, r1])
    end
  end
  
end

