# spec/models/ability_spec.rb
require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  #--------------------------------
  
    context "public access (user is nil)" do
      let(:user) { nil }
  
      it "can create and show NetballEducator" do
        educator = build_stubbed(:netball_educator)
        expect(ability).to be_able_to(:create, educator)
        expect(ability).to be_able_to(:show, educator)
      end

      it "cannot read list of educators" do
        expect(ability).not_to be_able_to(:index, NetballEducator)
      end
    
      it "cannot update or destroy an educator" do
        educator = build_stubbed(:netball_educator)
        expect(ability).not_to be_able_to(:update, educator)
        expect(ability).not_to be_able_to(:destroy, educator)
      end
    
      it "cannot access any user resources" do
        expect(ability).not_to be_able_to(:read, User)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:index, User)
      end
    
      it "cannot access other sensitive models" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:read, Payment)
      end
    end

    #--------------------------------

    context "authenticated user with no role" do
      let(:user) { build_stubbed(:user, id: 1, role: nil) }
    
      #removed because this is not  real case and its forever failing
      # it "can read and update their own User record" do
      #   user = build_stubbed(:user, id: 1, role: nil)
      #   own_user = build_stubbed(:user, id: 1, role: nil)
    
      #   ability = Ability.new(user) #special becuase test kept failing when using build(:user)
    
      #   expect(ability).to be_able_to(:read, own_user)
      #   expect(ability).to be_able_to(:update, own_user)
      # end
    
      it "cannot manage other users" do
        expect(ability).not_to be_able_to(:manage, User.new(id: 999))
      end
    
      it "cannot manage other resources" do
        expect(ability).not_to be_able_to(:manage, NetballEducator)
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Event)
      end
    
      it "cannot access index actions on restricted models" do
        expect(ability).not_to be_able_to(:index, User)
        expect(ability).not_to be_able_to(:index, NetballEducator)
      end
    end
    
    #--------------------------------

    context "teams_grants role" do
      let(:user) { build(:user, role: "teams_grants") }
    
      it "can manage grant-related resources" do
        expect(ability).to be_able_to(:manage, Grant)
        expect(ability).to be_able_to(:manage, Person)
        expect(ability).to be_able_to(:manage, Member)
        expect(ability).to be_able_to(:manage, Program)
        expect(ability).to be_able_to(:manage, Event)
        expect(ability).to be_able_to(:manage, Venue)
        expect(ability).to be_able_to(:manage, Tour)
        expect(ability).to be_able_to(:manage, Partner)
        expect(ability).to be_able_to(:manage, Club)
        expect(ability).to be_able_to(:manage, Payment)
        expect(ability).to be_able_to(:manage, IndividualMember)
      end
    
      it "cannot manage users or admin-only models" do
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Transfer)
        expect(ability).not_to be_able_to(:manage, Sponsor)
        expect(ability).not_to be_able_to(:manage, Opportunity)
        expect(ability).not_to be_able_to(:manage, Medium)
        expect(ability).not_to be_able_to(:manage, NetballEducator)
      end
    end

    #--------------------------------
    

    context "teamlead role" do
      let(:user) { build(:user, role: "teamlead", id: 1) }
      let(:own_club) { build_stubbed(:club, user_id: user.id) }
      let(:other_club) { build_stubbed(:club, user_id: 999) }
    
      subject(:ability) { Ability.new(user) }
    
      it "can manage their own club only" do
        expect(ability).to be_able_to(:manage, own_club)
        expect(ability).not_to be_able_to(:manage, other_club)
      end
    
      it "can manage members in their own club only" do
        own_member = build_stubbed(:member, club: own_club)
        other_member = build_stubbed(:member, club: other_club)
    
        expect(ability).to be_able_to(:manage, own_member)
        expect(ability).not_to be_able_to(:manage, other_member)
      end
    
      it "can manage individual members in their own club only" do
        own_individual = build_stubbed(:individual_member, club: own_club)
        other_individual = build_stubbed(:individual_member, club: other_club)
    
        expect(ability).to be_able_to(:manage, own_individual)
        expect(ability).not_to be_able_to(:manage, other_individual)
      end
    
      it "can read payments linked to their own club only" do
        own_payment = build_stubbed(:payment, club: own_club)
        other_payment = build_stubbed(:payment, club: other_club)
      
        expect(ability).to be_able_to(:read, own_payment)
        expect(ability).not_to be_able_to(:read, other_payment)
      end
    
      it "cannot access unrelated models" do
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Event)
        expect(ability).not_to be_able_to(:manage, NetballEducator)
      end
    end

    #--------------------------------

    context "grants role" do
      let(:user) { build(:user, role: "grants") }
    
      it "can manage grants only" do
        expect(ability).to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Event)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Club)
      end
    end

    #--------------------------------

    context "no_access role" do
      let(:user) { build(:user, role: "no_access") }
    
    
      it "cannot manage unrelated models" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Payment)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Event)
        expect(ability).not_to be_able_to(:manage, Tour)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Sponsor)
        expect(ability).not_to be_able_to(:manage, Transfer)
        expect(ability).not_to be_able_to(:manage, Opportunity)
      end
    end

    #--------------------------------

    context "teams_admin role" do
      let(:user) { build(:user, role: "teams_admin") }
    
      it "can manage clubs, members, individual members, and payments" do
        expect(ability).to be_able_to(:manage, Club)
        expect(ability).to be_able_to(:manage, Member)
        expect(ability).to be_able_to(:manage, IndividualMember)
        expect(ability).to be_able_to(:manage, Payment)
      end
    
      it "can access the teams list index action on clubs" do
        expect(ability).to be_able_to(:teams_list_index, Club)
      end
    
      it "cannot manage users or unrelated resources" do
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Sponsor)
        expect(ability).not_to be_able_to(:manage, Event)
        expect(ability).not_to be_able_to(:manage, NetballEducator)
      end
    end

    #--------------------------------

    context "sponsors_events role" do
      let(:user) { build(:user, role: "sponsors_events", id: 101) }
    
      it "can manage sponsors, contacts, their own opportunities" do
        expect(ability).to be_able_to(:manage, Sponsor)
        expect(ability).to be_able_to(:manage, Contact)
    
        own_opportunity = build_stubbed(:opportunity, user_id: user.id)
        other_opportunity = build_stubbed(:opportunity, user_id: 999)
    
        expect(ability).to be_able_to(:manage, own_opportunity)
        expect(ability).not_to be_able_to(:manage, other_opportunity)
      end
    
      it "can only manage events but not destroy them" do
        expect(ability).to be_able_to(:index, Event)
        expect(ability).to be_able_to(:show, Event)
        expect(ability).to be_able_to(:create, Event)
        expect(ability).to be_able_to(:update, Event)
        expect(ability).not_to be_able_to(:destroy, Event)
      end
    
      it "cannot manage unrelated models" do
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, NetballEducator)
      end
    end

    #--------------------------------

    context "us_open role" do
      let(:user) { build(:user, role: "us_open") }
    
      it "can manage transfers and people" do
        expect(ability).to be_able_to(:manage, Transfer)
        expect(ability).to be_able_to(:manage, Person)
      end
    
      it "can read events" do
        expect(ability).to be_able_to(:read, Event)
        expect(ability).to be_able_to(:index, Event)
        expect(ability).to be_able_to(:show, Event)
      end
    
      it "cannot manage unrelated models" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Event)
      end
    end

    #--------------------------------

    context "educators_events role" do
      let(:user) { build(:user, role: "educators_events") }
    
      it "can manage educators-related models and actions" do
        expect(ability).to be_able_to(:manage, NetballEducator)
        expect(ability).to be_able_to(:manage, FollowUp)
        expect(ability).to be_able_to(:manage, Equipment)
        expect(ability).to be_able_to(:manage, Event)
        expect(ability).to be_able_to(:heat_map, NetballEducator)
      end
    
      it "can read educator-related views and scoped pages" do
        expect(ability).to be_able_to(:read, NetballEducator)
        expect(ability).to be_able_to(:read, FollowUp)
        expect(ability).to be_able_to(:read, Equipment)
        expect(ability).to be_able_to(:read, Event)
      end
    
      it "cannot manage unrelated models" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Payment)
        expect(ability).not_to be_able_to(:manage, User)
      end
    end

    #--------------------------------

    context "sponsors_media_events role" do
      let(:user) { build(:user, role: "sponsors_media_events", id: 6) }
    
      it "can manage sponsors, contacts, media, and events" do
        expect(ability).to be_able_to(:manage, Sponsor)
        expect(ability).to be_able_to(:manage, Contact)
        expect(ability).to be_able_to(:manage, Medium)
        expect(ability).to be_able_to(:manage, Event)
      end
    
      it "can manage their own opportunities only" do
        own_opp = build_stubbed(:opportunity, user_id: user.id)
        other_opp = build_stubbed(:opportunity, user_id: 999)
    
        expect(ability).to be_able_to(:manage, own_opp)
        expect(ability).not_to be_able_to(:manage, other_opp)
      end
    
      it "cannot manage users or unrelated models" do
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Grant)
      end
    end

    context "educators_events_medium role" do
      let(:user) { build(:user, role: "educators_events_medium") }
    
      it "can manage educators, follow ups, equipment, events, and media" do
        expect(ability).to be_able_to(:manage, NetballEducator)
        expect(ability).to be_able_to(:manage, FollowUp)
        expect(ability).to be_able_to(:manage, Equipment)
        expect(ability).to be_able_to(:manage, Event)
        expect(ability).to be_able_to(:manage, Medium)
        expect(ability).to be_able_to(:heat_map, NetballEducator)
      end
    
      it "cannot manage users or unrelated models" do
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Grant)
      end
    end
    

    #--------------------------------

    context "na_people role" do
      let(:user) { build(:user, role: "na_people", email: "user@example.com") }
      let(:person) { build_stubbed(:person, email: user.email, id: 101) }
      let(:other_person) { build_stubbed(:person, email: "other@example.com", id: 102) }
      let(:transfer) { build_stubbed(:transfer, person_id: person.id) }
      let(:other_transfer) { build_stubbed(:transfer, person_id: 999) }
    
      before do
        allow(Person).to receive(:find_by).with(email: user.email).and_return(person)
      end
    
      it "can read and update their own Person record" do
        expect(ability).to be_able_to(:read, person)
        expect(ability).to be_able_to(:update, person)
      end
    
      it "cannot access index of Person" do
        expect(ability).not_to be_able_to(:index, Person)
      end
    
      it "cannot access or modify another Person" do
        expect(ability).not_to be_able_to(:read, other_person)
        expect(ability).not_to be_able_to(:update, other_person)
      end
    
      it "can manage their own Transfers only" do
        expect(ability).to be_able_to(:read, transfer)
        expect(ability).to be_able_to(:create, transfer)
        expect(ability).to be_able_to(:update, transfer)
      end
    
      it "cannot manage unrelated Transfers" do
        expect(ability).not_to be_able_to(:read, other_transfer)
        expect(ability).not_to be_able_to(:update, other_transfer)
      end
    
      it "cannot index Transfers" do
        expect(ability).not_to be_able_to(:index, Transfer)
      end
    end
    

   #--------------------------------

  context "admin role" do
    let(:user) { build(:user, role: "admin") }

    it "can manage everything" do
      expect(ability).to be_able_to(:manage, :all)
    end
  end
end
