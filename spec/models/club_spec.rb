require 'rails_helper'

RSpec.describe Club, type: :model do
  let(:club) { create(:club) }

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:us_state) }
    it { should validate_presence_of(:membership_category).on(:create) }
    it { should validate_presence_of(:estimate_total_number_of_club_members).on(:create) }
    it { should validate_presence_of(:estimate_total_active_members).on(:create) }
   # it { should validate_presence_of(:estimate_total_part_time_members).on(:create) }
  end

  describe "associations" do
    it { should have_many(:members).dependent(:destroy) }
    it { should have_many(:member_key_roles).dependent(:destroy) }
    it { should have_many(:individual_members) }
    it { should have_many(:payments) }
    it { should have_many(:teams) }
    it { should have_many(:notes).dependent(:destroy) }
    it { should belong_to(:creator).class_name('User') }
  end

  describe "methods" do
    let(:club) { create(:club) }

    it "returns 'Payment Due' if no payments" do
      expect(club.has_paid).to eq("Payment Due")
    end

    it "correctly detects renewed year" do
      club.update(renewal_years: "2023,2024")
      expect(club.renewed_for_year?(2024)).to be true
      expect(club.renewed_for_year?(2025)).to be false
    end

    it "correctly totals members" do
      create(:member, club: club)
      create(:individual_member, club: club)
      expect(club.club_total_members).to eq(2)
    end
  end

  describe "callbacks" do
    it "titleizes name and city on create" do
      club = create(:club, name: "my club", city: "big city")
      expect(club.name).to eq("My Club")
      expect(club.city).to eq("Big City")
    end

    it "defaults estimate_total_part_time_members to 0 if nil" do
      club = create(:club, estimate_total_part_time_members: nil)
      expect(club.estimate_total_part_time_members).to eq(0)
    end

   
  end

    describe "#key_roles_filled_count & #key_roles_status" do
      it "returns 0/4 when no roles are filled" do
        expect(club.key_roles_status).to eq("0/4")
      end
  
      it "returns correct filled count" do
        create(:member_key_role, club: club, key_role: "Club President")
        expect(club.key_roles_status).to eq("1/4")
      end
    end
  
    describe "#club_president and phone" do
      it "returns full name and phone if club president exists" do
        member = create(:member, first_name: "Jessie", last_name: "Sparks", phone: "555-1234")
        create(:member_key_role, club: club, key_role: "Club President", member: member)
        expect(club.club_president).to eq("Jessie Sparks")
        expect(club.club_president_phone).to eq("555-1234")
      end
  
      it "returns fallback if club president is missing" do
        expect(club.club_president).to eq("Please nominate")
        expect(club.club_president_phone).to eq("")
      end
    end
  
    describe "#head_coach, #head_umpire, #club_key_contact" do
      it "returns fallback when roles are missing" do
        expect(club.head_coach).to eq("Please nominate")
        expect(club.head_umpire).to eq("Please nominate")
        expect(club.club_key_contact).to eq("Please nominate")
      end
  
      it "returns member names if roles exist" do
        coach = create(:member, first_name: "Coach", last_name: "K")
        umpire = create(:member, first_name: "Ump", last_name: "Ump")
        contact = create(:member, first_name: "Key", last_name: "Person")
        create(:member_key_role, club: club, key_role: "Head Coach", member: coach)
        create(:member_key_role, club: club, key_role: "Head Umpire", member: umpire)
        create(:member_key_role, club: club, key_role: "Club Key Contact", member: contact)
  
        expect(club.head_coach).to eq("Coach K")
        expect(club.head_umpire).to eq("Ump Ump")
        expect(club.club_key_contact).to eq("Key Person")
      end
    end
  
    describe "#club_payments_total and last year" do
      let(:current_year) { ApplicationController.helpers.current_membership_year }
      let(:last_year) { current_year - 1 }
  
      it "returns total paid this year" do
        create(:payment, club: club, payment_year: current_year, amount: 80)
        create(:payment, club: club, payment_year: current_year, amount: 20)
        expect(club.club_payments_total).to eq(100)
      end
  
      it "returns total paid last year" do
        create(:payment, club: club, payment_year: last_year, amount: 30)
        expect(club.club_payments_total_last_year).to eq(30)
      end
    end
  
    describe "#club_total_active_members and part-time members" do
      it "counts active and part-time members across models" do
        create(:member, club: club, engagement_status: "Active")
        create(:individual_member, club: club, engagement_status: "Active")
        create(:member, club: club, engagement_status: "Part-Time")
        expect(club.club_total_active_members).to eq(2)
        expect(club.club_total_parttime_members).to eq(1)
      end
    end
  
    describe "#has_youth?" do
      it "returns true if youth members are present" do
        create(:member, club: club, age_status: "Youth")
        expect(club.has_youth?).to be true
      end
  
      it "returns false if no youth members" do
        expect(club.has_youth?).to be false
      end
    end
  
    describe "#new_this_year?" do
      it "returns true if created this year" do
        club = create(:club, created_at: Date.today)
        expect(club.new_this_year?).to be true
      end
  
      it "returns false if created in previous year" do
        club = create(:club, created_at: Date.new(Date.today.year - 1, 1, 1))
        expect(club.new_this_year?).to be false
      end
    end
 
end

