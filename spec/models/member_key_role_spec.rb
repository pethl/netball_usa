require 'rails_helper'

RSpec.describe MemberKeyRole, type: :model do
  let(:club) { create(:club) }
  let(:member) { create(:member, club: club) }

  subject { build(:member_key_role, club: club, member_id: member.id) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a key_role" do
      subject.key_role = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a member_id" do
      subject.member_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid without a club_id" do
      subject.club_id = nil
      expect(subject).not_to be_valid
    end

    it "is not valid with a duplicate key_role for the same club" do
      create(:member_key_role, key_role: "Club President", club: club)
      duplicate = build(:member_key_role, key_role: "Club President", club: club)
      expect(duplicate).not_to be_valid
    end
  end

  describe "valid key_role values from reference data" do
    Reference.where(group: 'member_positions').pluck(:value).each do |role|
      it "is valid with key_role: #{role}" do
        role_record = build(:member_key_role, key_role: role, club: club, member_id: member.id)
        expect(role_record).to be_valid
      end
    end
  end

  describe "associations" do
    it { should belong_to(:club) }
  end

  describe "scopes" do
    it "orders by key_role descending" do
      r1 = create(:member_key_role, key_role: "Zebra Coach")
      r2 = create(:member_key_role, key_role: "Alpha Lead")
  
      ordered_roles = MemberKeyRole.ordered
  
      # just check that r1 comes before r2
      expect(ordered_roles.index(r1)).to be < ordered_roles.index(r2)
    end
  end
end
