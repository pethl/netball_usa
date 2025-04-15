require 'rails_helper'

RSpec.describe Tour, type: :model do
  subject { build(:tour) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a company" do
      subject.company = nil
      expect(subject).to_not be_valid
    end
  end

  describe "#contact_two_blank" do
    it "returns true when any second contact field is present" do
      subject.first_name_secondary = "Lee"
      expect(subject.contact_two_blank).to eq(true)
    end

    it "returns false when all second contact fields are blank" do
      subject.assign_attributes(
        first_name_secondary: "", last_name_secondary: "",
        role_secondary: "", email_secondary: "",
        cell_secondary: "", work_phone_secondary: ""
      )
      expect(subject.contact_two_blank).to eq(false)
    end
  end

  describe "#contact_three_blank" do
    it "returns true when any third contact field is present" do
      subject.email_third = "third@example.com"
      expect(subject.contact_three_blank).to eq(true)
    end

    it "returns false when all third contact fields are blank" do
      subject.assign_attributes(
        first_name_third: "", last_name_third: "",
        role_third: "", email_third: "",
        cell_third: "", work_phone_third: ""
      )
      expect(subject.contact_three_blank).to eq(false)
    end
  end

  describe "#address_condensed" do
    it "returns full address when all fields present" do
      expect(subject.address_condensed).to eq("Main Campus, Orlando, FL")
    end

    it "handles missing location" do
      subject.location = nil
      expect(subject.address_condensed).to eq("Orlando, FL")
    end

    it "returns empty string when all parts blank" do
      subject.location = subject.city = subject.us_state = nil
      expect(subject.address_condensed).to eq("")
    end
  end
end

