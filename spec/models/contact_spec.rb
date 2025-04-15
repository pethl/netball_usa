require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:sponsor) { create(:sponsor) }
  subject { build(:contact, sponsor: sponsor) }


  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a first name" do
      subject.first_name = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a last name" do
      subject.last_name = nil
      expect(subject).not_to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:sponsor) }
    # Uncomment the following if partner association is re-added
    # it { should belong_to(:partner).optional }
  end

  describe "scopes" do
    it "orders contacts by last name ascending" do
      c1 = create(:contact, last_name: "Zebra", sponsor: sponsor)
      c2 = create(:contact, last_name: "Apple", sponsor: sponsor)
      expect(Contact.where(id: [c1.id, c2.id]).ordered).to eq([c2, c1])
    end
  end
  

  describe "#full_name" do
  it "includes prefix and suffix when both present" do
    contact = build(:contact, prefix: "Dr.", suffix: "PhD", first_name: "Jane", last_name: "Smith")
    expect(contact.full_name).to eq("Dr. Jane Smith PhD")
  end

  it "includes only prefix when suffix is missing" do
    contact = build(:contact, prefix: "Dr.", suffix: nil, first_name: "Jane", last_name: "Smith")
    expect(contact.full_name).to eq("Dr. Jane Smith")
  end

  it "includes only suffix when prefix is missing" do
    contact = build(:contact, prefix: nil, suffix: "Esq.", first_name: "Jane", last_name: "Smith")
    expect(contact.full_name).to eq("Jane Smith Esq.")
  end

  it "includes only first and last name when no prefix/suffix" do
    contact = build(:contact, prefix: nil, suffix: nil, first_name: "Jane", last_name: "Smith")
    expect(contact.full_name).to eq("Jane Smith")
  end
end
end

