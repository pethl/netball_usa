require 'rails_helper'

RSpec.describe Region, type: :model do
  describe "validations" do
    it "is valid with valid attributes" do
      Region.where(state: "TX").destroy_all
      expect(build(:region, state: "TX")).to be_valid
    end

    it "is not valid with duplicate state" do
      Region.where(state: "CA").destroy_all
      create(:region, state: "CA")
      dup = build(:region, state: "CA")
      expect(dup).not_to be_valid
      expect(dup.errors[:state]).to include("is already assigned to a region")
    end
  end

  describe "scopes" do
    it "orders by region descending (includes test records in correct order)" do
      Region.where(state: %w[ZZ1 ZZ2]).destroy_all
      r1 = create(:region, region: "West", state: "ZZ1")
      r2 = create(:region, region: "East", state: "ZZ2")
  
      ordered = Region.ordered.where(id: [r1.id, r2.id])
      expect(ordered).to eq([r1, r2])
    end
  end

  describe "#states_in_region" do
    it "returns all states in the same region" do
      Region.where(state: %w[NY MA NJ]).destroy_all
      create(:region, state: "NY", region: "Northeast")
      create(:region, state: "MA", region: "Northeast")
      base = create(:region, state: "NJ", region: "Northeast")

      expect(base.states_in_region).to contain_exactly("NY", "MA", "NJ")
    end
  end

  describe "#clubs_in_region" do
    let(:region) do
      Region.where(state: "FL").destroy_all
      create(:region, region: "Southeast", state: "FL")
    end

    before do
      Region.where(state: "GA").destroy_all
      create(:region, region: "Southeast", state: "GA")

      @club1 = create(:club, us_state: "FL")
      @club2 = create(:club, us_state: "GA")
      create(:club, us_state: "CA") # unrelated
    end

    it "returns clubs in states of this region" do
      expect(region.clubs_in_region).to contain_exactly(@club1, @club2)
    end
  end
end


