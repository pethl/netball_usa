require 'rails_helper'

RSpec.describe Opportunity, type: :model do
  let(:sponsor) { create(:sponsor) }
  let(:user) { create(:user) }

  subject { build(:opportunity, sponsor: sponsor, user: user) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a sponsor" do
      subject.sponsor = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a user" do
      subject.user = nil
      expect(subject).not_to be_valid
    end
  end

  describe "associations" do
    it { should belong_to(:sponsor) }
    it { should belong_to(:user) }
  end

  describe "scopes" do
    it "orders by created_at ascending" do
      o1 = create(:opportunity, created_at: 2.days.ago, sponsor: sponsor, user: user)
      o2 = create(:opportunity, created_at: 1.day.ago, sponsor: sponsor, user: user)
    
      ordered = Opportunity.ordered
    
      expect(ordered.index(o1)).to be < ordered.index(o2)
    end
  end
end

