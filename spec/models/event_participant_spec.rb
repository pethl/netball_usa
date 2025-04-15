require 'rails_helper'

RSpec.describe EventParticipant, type: :model do
  let(:event) { create(:event) }
  let(:person) { create(:person) }
  let(:netball_educator) { create(:netball_educator) }

  describe "validations" do
    it "is valid with a person and no netball_educator" do
      ep = build(:event_participant, event: event, person: person, netball_educator: nil)
      expect(ep).to be_valid
    end

    it "is valid with a netball_educator and no person" do
      ep = build(:event_participant, event: event, person: nil, netball_educator: netball_educator)
      expect(ep).to be_valid
    end

    it "is not valid with neither person nor netball_educator" do
      ep = build(:event_participant, event: event, person: nil, netball_educator: nil)
      expect(ep).to_not be_valid
      expect(ep.errors[:base]).to include("Either person or netball educator must be present")
    end

    it "is not valid with both person and netball_educator" do
      ep = build(:event_participant, event: event, person: person, netball_educator: netball_educator)
      expect(ep).to_not be_valid
      expect(ep.errors[:base]).to include("Only one of person or netball educator can be present")
    end
  end
end


