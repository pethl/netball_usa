require 'rails_helper'

RSpec.describe Team, type: :model do
  subject { Team.new(name: "Seattle Scorcers", user_id: 10 )}
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a name" do
      subject.name=nil
      expect(subject).to_not be_valid
    end

    describe "associations" do
      it { should belong_to(:club).optional }
      it { should have_many(:members) }
      it { should have_many(:individual_members) }
    end

    it "can have many members" do
      team = create(:team)
      member1 = create(:member, team: team)
      member2 = create(:member, team: team)
    
      expect(team.members).to include(member1, member2)
      expect(team.members.count).to eq(2)
    end
   
end
