require 'rails_helper'

RSpec.describe FollowUp, type: :model do
  let(:netball_educator) { create(:netball_educator) }
  let(:user) { create(:user) }
  let(:event) { create(:event) }

  subject do
    build(:follow_up, netball_educator: netball_educator, user: user, event: event)
  end

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    #not currenty enforced
    # it "is not valid without a netball_educator" do
    #   subject.netball_educator = nil
    #   expect(subject).to_not be_valid
    #   expect(subject.errors[:netball_educator]).to include("must be linked ")
    # end
  end

  describe "associations" do
    it { should belong_to(:netball_educator).optional }
    it { should belong_to(:user).optional }
    it { should belong_to(:event).optional }
  end
end

