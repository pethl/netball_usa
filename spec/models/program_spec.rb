require 'rails_helper'

RSpec.describe Program, type: :model do
  let(:person) { create(:person) }
  subject { build(:program, person: person) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a program_name" do
      subject.program_name = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:program_name]).to include("can't be blank")
    end

    it "is not valid without a program_stage" do
      subject.program_stage = nil
      expect(subject).to_not be_valid
      expect(subject.errors[:program_stage]).to include("can't be blank")
    end
  end

  describe "associations" do
    it { should belong_to(:person).optional }
  end
end
