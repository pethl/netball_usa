# spec/models/vendor_spec.rb
require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "validations" do
    let(:vendor) { build(:vendor) }

    it "is valid with valid attributes and a vendor category reference" do
      category = create(:reference, group: "vendor_category", value: "Printing")
      vendor.references << category
      expect(vendor).to be_valid
    end

    it "is not valid without a company name" do
      vendor.company_name = nil
      expect(vendor).not_to be_valid
      expect(vendor.errors[:company_name]).to include("can't be blank")
    end

    it "is not valid without at least one vendor category reference" do
      vendor.references.clear
      expect(vendor).not_to be_valid
      expect(vendor.errors[:references]).to include("must include at least one category")
    end

    it "is valid if it has a non-category reference and a category reference" do
      category = create(:reference, group: "vendor_category", value: "Uniforms")
      non_category = create(:reference, group: "other", value: "Not a category")
      vendor.references << [category, non_category]
      expect(vendor).to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:reference_vendors) }
    it { should have_many(:references).through(:reference_vendors) }
  end
end

