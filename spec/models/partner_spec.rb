require 'rails_helper'

RSpec.describe Partner, type: :model do
  let(:user) { create(:user) }
  subject { build(:partner, user: user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a company name" do
      subject.company = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:company]).to include(": Please enter name before attempting to save")
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:contacts) }
   # it { should have_one(:person) } - not needed currently
  end

  describe "scopes" do
    it "orders by company name ascending" do
      p1 = create(:partner, company: "Alpha Org", user: user)
      p2 = create(:partner, company: "Beta Org", user: user)
    
      scoped = Partner.where(id: [p1.id, p2.id]).ordered
      expect(scoped).to eq([p1, p2])
    end
    
  end

  describe "#contact_two_blank" do
    it "returns false when all fields are blank" do
      subject.assign_attributes(
        first_name_secondary: nil,
        last_name_secondary: nil,
        role_secondary: nil,
        email_secondary: nil,
        cell_secondary: nil,
        work_phone_secondary: nil
      )
      expect(subject.contact_two_blank).to eq(false)
    end

    it "returns true when any field is present" do
      subject.email_secondary = "someone@partner.org"
      expect(subject.contact_two_blank).to eq(true)
    end
  end

  describe "#contact_three_blank" do
    it "returns false when all fields are blank" do
      subject.assign_attributes(
        first_name_third: nil,
        last_name_third: nil,
        role_third: nil,
        email_third: nil,
        cell_third: nil,
        work_phone_third: nil
      )
      expect(subject.contact_three_blank).to eq(false)
    end

    it "returns true when any field is present" do
      subject.first_name_third = "Ana"
      expect(subject.contact_three_blank).to eq(true)
    end
  end

  describe "#address_condensed" do
    it "returns full address when all fields present" do
      expect(subject.address_condensed).to eq("#{subject.location}, #{subject.city}, #{subject.us_state} #{subject.country}")
    end

    it "returns partial address when some fields are blank" do
      subject.location = nil
      expect(subject.address_condensed).to include(subject.city)
    end
  end
end

