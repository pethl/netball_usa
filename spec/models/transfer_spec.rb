require 'rails_helper'

RSpec.describe Transfer, type: :model do
  let(:person) { create(:person) }
  let(:event) { create(:event) }

  subject do
    build(:transfer, person: person, event: event)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a person" do
      subject.person = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:person]).to include("must exist")
    end

    it "is not valid without an event" do
      subject.event = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:event]).to include("must exist")
    end
  end

  describe "associations" do
    it { should belong_to(:person) }
    it { should belong_to(:event) }
  end

  describe "association behavior" do
    it "associates with a person" do
      expect(subject.person).to eq(person)
    end

    it "associates with an event" do
      expect(subject.event).to eq(event)
    end
  end
end

