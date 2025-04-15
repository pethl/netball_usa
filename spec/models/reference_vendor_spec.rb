require 'rails_helper'

RSpec.describe ReferenceVendor, type: :model do
  describe "associations" do
    it { should belong_to(:vendor) }
    it { should belong_to(:reference) }
  end

  describe "validations" do
    it "is valid with valid attributes" do
      ref_vendor = build(:reference_vendor)
      expect(ref_vendor).to be_valid
    end

    it "is not valid without a vendor" do
      ref_vendor = build(:reference_vendor, vendor: nil)
      expect(ref_vendor).not_to be_valid
    end

    it "is not valid without a reference" do
      ref_vendor = build(:reference_vendor, reference: nil)
      expect(ref_vendor).not_to be_valid
    end
  end
end

