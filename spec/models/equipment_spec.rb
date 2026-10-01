require "rails_helper"

RSpec.describe Equipment, type: :model do
  describe "associations" do
    it { should belong_to(:netball_educator).optional }
  end

  describe "validations" do
    it { should validate_presence_of(:status) }
  end

  describe "scopes" do
    let!(:quote) { create(:equipment, :quote, :without_educator) }
    let!(:sale) { create(:equipment, :sale, :without_educator) }

    it "returns only quotes" do
      expect(described_class.quotes).to include(quote)
      expect(described_class.quotes).not_to include(sale)
    end

    it "returns only sales" do
      expect(described_class.sales).to include(sale)
      expect(described_class.sales).not_to include(quote)
    end
  end

  describe "status helpers" do
    it "identifies a quote" do
      equipment = build(:equipment, :quote, :without_educator)

      expect(equipment).to be_quote
      expect(equipment).not_to be_sale
    end

    it "identifies a sale" do
      equipment = build(:equipment, :sale, :without_educator)

      expect(equipment).to be_sale
      expect(equipment).not_to be_quote
    end
  end
end
