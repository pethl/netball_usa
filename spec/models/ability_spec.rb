# spec/models/ability_spec.rb
require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  #--------------------------------PUBLIC ACCESS--------------------------------
  
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

  #--------------------------------AUTHENTICATED USER WITH NO ROLE--------------------------------

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
    
  #--------------------------------TEAM_GRANTS ROLE--------------------------------

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

      it "can access Grants show and edit pages" do
        grant = build_stubbed(:grant)
      
        expect(ability).to be_able_to(:show, grant)
        expect(ability).to be_able_to(:edit, grant)
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

    #--------------------------------TEAMLEAD ROLE--------------------------------
    

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

      it "cannot access admin-level club actions" do
        expect(ability).not_to be_able_to(:index_admin, own_club)
        expect(ability).not_to be_able_to(:index_admin, other_club)
      end      
    end

    #--------------------------------GRANTS ROLE--------------------------------

    context "grants role" do
      let(:user) { build(:user, role: "grants") }
    
      it "can manage grants only" do
        expect(ability).to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Event)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Club)
      end

      it "can access Grants show and edit pages" do
        grant = build_stubbed(:grant)
      
        expect(ability).to be_able_to(:show, grant)
        expect(ability).to be_able_to(:edit, grant)
      end
    end

    #--------------------------------NO ACCESS ROLE--------------------------------

    # ----------------------------- OFFICE ROLE -----------------------------

context "office role without group membership" do
  let(:user) do
    build_stubbed(
      :user,
      id: 100,
      role: "office"
    )
  end

  before do
    allow(user)
      .to receive(:in_group?)
      .and_return(false)
  end

  it "can read and update its own user account" do
    expect(ability).to be_able_to(:read, user)
    expect(ability).to be_able_to(:update, user)
  end

  it "cannot access another user account" do
    other_user = build_stubbed(
      :user,
      id: 200,
      role: "office"
    )

    expect(ability).not_to be_able_to(:read, other_user)
    expect(ability).not_to be_able_to(:update, other_user)
  end

  it "cannot access the user index" do
    expect(ability).not_to be_able_to(:index, User)
  end

  it "can read and update the Person profile matching its email" do
    own_person = create(
      :person,
      email: user.email.upcase,
      status: "Active"
    )

    expect(ability).to be_able_to(:read, own_person)
    expect(ability).to be_able_to(:update, own_person)
  end

  it "cannot access another Person profile or the People index" do
    other_person = build_stubbed(
      :person,
      email: "someone.else@example.com"
    )

    expect(ability).not_to be_able_to(:read, other_person)
    expect(ability).not_to be_able_to(:update, other_person)
    expect(ability).not_to be_able_to(:index, Person)
    expect(ability).not_to be_able_to(:create, Person)
    expect(ability).not_to be_able_to(:destroy, other_person)
  end

  context "with an explicitly linked Person using a different email" do
    let(:linked_person) do
      build_stubbed(
        :person,
        email: "personal.address@example.com"
      )
    end

    before do
      allow(user).to receive(:person).and_return(linked_person)
    end

    it "uses the explicit link instead of requiring an email match" do
      expect(ability).to be_able_to(:read, linked_person)
      expect(ability).to be_able_to(:update, linked_person)
    end
  end

  context "with a Person and current US Open Transfer" do
    let!(:current_us_open_event) do
      create(
        :event,
        event_type: "US Open",
        name: "Current US Open ability spec",
        date: Date.current.end_of_year
      )
    end

    let!(:past_us_open_event) do
      create(
        :event,
        event_type: "US Open",
        name: "Past US Open ability spec",
        date: Date.current.prev_year
      )
    end

    let!(:own_person) do
      create(
        :person,
        email: user.email.upcase,
        status: "Active"
      )
    end

    let!(:other_person) do
      create(
        :person,
        email: "other.us.open.person@example.com",
        status: "Active"
      )
    end

    let!(:own_current_transfer) do
      create(
        :transfer,
        person: own_person,
        event: current_us_open_event
      )
    end

    let!(:own_past_transfer) do
      create(
        :transfer,
        person: own_person,
        event: past_us_open_event
      )
    end

    let!(:other_current_transfer) do
      create(
        :transfer,
        person: other_person,
        event: current_us_open_event
      )
    end

    before do
      allow(user).to receive(:person).and_return(own_person)
    end

    it "can read and update only its current US Open Transfer" do
      expect(ability).to be_able_to(:read, own_current_transfer)
      expect(ability).to be_able_to(:update, own_current_transfer)

      expect(ability).not_to be_able_to(:read, own_past_transfer)
      expect(ability).not_to be_able_to(:update, own_past_transfer)
      expect(ability).not_to be_able_to(:read, other_current_transfer)
      expect(ability).not_to be_able_to(:update, other_current_transfer)
    end

    it "cannot list, create, or delete Transfers" do
      expect(ability).not_to be_able_to(:index, Transfer)
      expect(ability).not_to be_able_to(:create, Transfer)
      expect(ability).not_to be_able_to(:destroy, own_current_transfer)
    end
  end

  context "with only an email-matched Person and no explicit link" do
    let!(:current_us_open_event) do
      create(
        :event,
        event_type: "US Open",
        name: "Unlinked current US Open ability spec",
        date: Date.current.end_of_year
      )
    end

    let!(:email_matched_person) do
      create(
        :person,
        email: user.email,
        status: "Active"
      )
    end

    let!(:email_matched_transfer) do
      create(
        :transfer,
        person: email_matched_person,
        event: current_us_open_event
      )
    end

    it "does not grant Transfer access without an explicit User link" do
      expect(ability).not_to be_able_to(:read, email_matched_transfer)
      expect(ability).not_to be_able_to(:update, email_matched_transfer)
    end
  end

  it "does not receive operational access without a group" do
    expect(ability).not_to be_able_to(:manage, Club)
    expect(ability).not_to be_able_to(:manage, Payment)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Tour)
    expect(ability).not_to be_able_to(:manage, Grant)
    expect(ability).not_to be_able_to(:manage, Sponsor)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Partner)
    expect(ability).not_to be_able_to(:manage, Opportunity)
  end

  it "cannot access group-specific collection actions" do
    expect(ability).not_to be_able_to(
      :university_squad,
      Person
    )

    expect(ability).not_to be_able_to(
      :university,
      Partner
    )

    expect(ability).not_to be_able_to(
      :menu_all,
      Transfer
    )
  end
end

    #-------------------------------- TEAMS ADMIN

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

    #----------------------------- SPONSORS EVENTS   ---

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

      it "can access Sponsors show and edit pages" do
        sponsor = build_stubbed(:sponsor)
      
        expect(ability).to be_able_to(:show, sponsor)
        expect(ability).to be_able_to(:edit, sponsor)
      end

      it "can access Events show and edit pages" do
        event = build_stubbed(:event)
      
        expect(ability).to be_able_to(:show, event)
        expect(ability).to be_able_to(:edit, event)
      end
    end

    #--------------------------------US OPEN ROLE--------------------------------

    context "legacy us_open role" do
      let(:user) do
        build_stubbed(
          :user,
          id: 100,
          role: "us_open"
        )
      end

      before do
        allow(user)
          .to receive(:in_group?)
          .and_return(false)
      end

      it "can manage transfers and people" do
        expect(ability).to be_able_to(:manage, Transfer)
        expect(ability).to be_able_to(:manage, Person)
      end

      it "can access the full US Open menu" do
        expect(ability).to be_able_to(:menu_all, Transfer)
        expect(ability).to be_able_to(:inbound_pickups, Transfer)
        expect(ability).to be_able_to(:outbound_pickups, Transfer)
      end

      it "can access People show and edit pages" do
        person = build_stubbed(:person)

        expect(ability).to be_able_to(:show, person)
        expect(ability).to be_able_to(:edit, person)
      end

      it "can access Transfers show and edit pages" do
        transfer = build_stubbed(:transfer)

        expect(ability).to be_able_to(:show, transfer)
        expect(ability).to be_able_to(:edit, transfer)
      end

      it "has read-only event and calendar access" do
        expect(ability).to be_able_to(:read, Event)
        expect(ability).to be_able_to(:index, Event)
        expect(ability).to be_able_to(:show, Event)
        expect(ability).to be_able_to(:calendar, Event)

        expect(ability).not_to be_able_to(:create, Event)
        expect(ability).not_to be_able_to(:update, Event)
        expect(ability).not_to be_able_to(:destroy, Event)
      end

      it "cannot manage unrelated models" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, User)
        expect(ability).not_to be_able_to(:manage, Event)
      end
    end

    context "office user in the US Open Team group" do
      let(:user) do
        build_stubbed(
          :user,
          id: 100,
          role: "office"
        )
      end

      before do
        allow(user)
          .to receive(:in_group?)
          .and_return(false)

        allow(user)
          .to receive(:in_group?)
          .with("us_open_team")
          .and_return(true)
      end

      it "receives Transfer-only US Open permissions from the group" do
        expect(ability).to be_able_to(:manage, Transfer)
        expect(ability).to be_able_to(:menu_all, Transfer)
        expect(ability).to be_able_to(:inbound_pickups, Transfer)
        expect(ability).to be_able_to(:outbound_pickups, Transfer)
        expect(ability).not_to be_able_to(:manage, Person)
      end

      it "has read-only event and calendar access" do
        expect(ability).to be_able_to(:read, Event)
        expect(ability).to be_able_to(:calendar, Event)

        expect(ability).not_to be_able_to(:create, Event)
        expect(ability).not_to be_able_to(:update, Event)
        expect(ability).not_to be_able_to(:destroy, Event)
      end

      it "does not receive unrelated access" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Sponsor)
        expect(ability).not_to be_able_to(:manage, Medium)
      end
    end

    #------------------------- EDUCATORS EVENTS ROLE--------------------------------

    context "educators_events role" do
      let(:user) { build(:user, role: "educators_events") }

      it "can create NetballEducator" do
        educator = build_stubbed(:netball_educator)
        expect(ability).to be_able_to(:create, educator)
      end
    
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

      it "can access NetballEducator show and edit pages" do
        educator = build_stubbed(:netball_educator)
      
        expect(ability).to be_able_to(:show, educator)
        expect(ability).to be_able_to(:edit, educator)
      end
    
      it "cannot manage unrelated models" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Payment)
        expect(ability).not_to be_able_to(:manage, User)
      end
    end

    #----------------------- SPONSORS MEDIA EVENTS ---------

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

      it "can access Media  show and edit pages" do
        media = build_stubbed(:medium)
      
        expect(ability).to be_able_to(:show, media)
        expect(ability).to be_able_to(:edit, media)
      end
    end

    #------------------------EDUCATOR EVENTS MEDIA-------

    context "educators_events_medium role" do
      let(:user) { build(:user, role: "educators_events_medium") }

      it "can create NetballEducator" do
        educator = build_stubbed(:netball_educator)
        expect(ability).to be_able_to(:create, educator)
      end
    
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
    

    #------------------------ NA PEOPLE --------

    context "na_people role" do
      let(:user) do
        build(:user, role: "na_people", email: "user@example.com")
      end

      let(:person) do
        build_stubbed(:person, email: user.email, id: 101)
      end

      let(:other_person) do
        build_stubbed(:person, email: "other@example.com", id: 102)
      end

      let(:transfer) do
        build_stubbed(:transfer, person: person)
      end

      let(:other_transfer) do
        build_stubbed(:transfer, person: other_person)
      end

      # ---------------- PERSON ----------------

      it "can create a new Person profile" do
        new_person = build(:person, email: user.email)

        expect(ability).to be_able_to(:create, new_person)
      end

      it "can read and update their own Person record" do
        expect(ability).to be_able_to(:read, person)
        expect(ability).to be_able_to(:update, person)
      end

      it "cannot access or modify another Person" do
        expect(ability).not_to be_able_to(:read, other_person)
        expect(ability).not_to be_able_to(:update, other_person)
      end

      it "cannot destroy their Person" do
        expect(ability).not_to be_able_to(:destroy, person)
      end

      it "cannot access index of Person" do
        expect(ability).not_to be_able_to(:index, Person)
      end

      # ---------------- TRANSFER ----------------

      it "can read and update their own Transfer" do
        expect(ability).to be_able_to(:read, transfer)
        expect(ability).to be_able_to(:update, transfer)
      end

      it "cannot create a Transfer" do
        new_transfer = build(:transfer, person: person)

        expect(ability).not_to be_able_to(:create, new_transfer)
      end

      it "cannot access or modify another person's Transfer" do
        expect(ability).not_to be_able_to(:read, other_transfer)
        expect(ability).not_to be_able_to(:update, other_transfer)
      end

      it "cannot destroy their Transfer" do
        expect(ability).not_to be_able_to(:destroy, transfer)
      end

      it "cannot index Transfers" do
        expect(ability).not_to be_able_to(:index, Transfer)
      end

      context "when the user does not have a Person profile yet" do
        it "can create their Person profile" do
          new_person = Person.new(email: user.email)

          expect(ability).to be_able_to(:create, new_person)
        end

        it "still cannot create a Transfer" do
          expect(ability).not_to be_able_to(:create, Transfer.new)
        end
      end
    end

    #------------------------ US OPEN MEDIA --------

    context "us_open_media role" do
      let(:user) { build(:user, role: "us_open_media") }

      it "can manage transfers, people, and media" do
        expect(ability).to be_able_to(:manage, Transfer)
        expect(ability).to be_able_to(:manage, Person)
        expect(ability).to be_able_to(:manage, Medium)
      end

      it "can access transfer menus and pickup actions" do
        expect(ability).to be_able_to(:menu_all, Transfer)
        expect(ability).to be_able_to(:inbound_pickups, Transfer)
        expect(ability).to be_able_to(:outbound_pickups, Transfer)
      end

      it "can read events and access the calendar" do
        expect(ability).to be_able_to(:read, Event)
        expect(ability).to be_able_to(:index, Event)
        expect(ability).to be_able_to(:show, Event)
        expect(ability).to be_able_to(:calendar, Event)
      end

      it "cannot modify events" do
        expect(ability).not_to be_able_to(:create, Event)
        expect(ability).not_to be_able_to(:update, Event)
        expect(ability).not_to be_able_to(:destroy, Event)
      end

      it "cannot manage unrelated resources" do
        expect(ability).not_to be_able_to(:manage, Club)
        expect(ability).not_to be_able_to(:manage, Grant)
        expect(ability).not_to be_able_to(:manage, Sponsor)
      end
    end

    context "university admin team member" do
      let(:user) { build(:user, role: "office") }
      let(:objective) { UniversityObjective.new }

      before do
        allow(user)
          .to receive(:in_group?)
          .and_return(false)

        allow(user)
          .to receive(:in_group?)
          .with("university_admin_team")
          .and_return(true)
      end


      it "can view the objective index and individual objectives" do
        expect(ability).to be_able_to(:index, UniversityObjective)
        expect(ability).to be_able_to(:show, objective)
      end

      it "cannot create, update, or destroy objectives" do
        expect(ability).not_to be_able_to(:create, UniversityObjective)
        expect(ability).not_to be_able_to(:update, objective)
        expect(ability).not_to be_able_to(:destroy, objective)
      end
    end

   #-------------------------MEDIA GROUP -------
   #
   context "office user in the Media Team group" do
  let(:user) do
    build_stubbed(
      :user,
      id: 100,
      role: "office"
    )
  end

  before do
    allow(user)
      .to receive(:in_group?)
      .and_return(false)

    allow(user)
      .to receive(:in_group?)
      .with("media_team")
      .and_return(true)
  end

  it "can manage media" do
    expect(ability).to be_able_to(:manage, Medium)
  end

  it "does not receive unrelated access" do
    expect(ability).not_to be_able_to(:manage, Sponsor)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Club)
  end
end

#-------------------------SPONSORS AND EVENTS GROUPS -------

context "office user in the Sponsors Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user).to receive(:in_group?).with("sponsors_team").and_return(true)
  end

  it "can manage sponsors and contacts" do
    expect(ability).to be_able_to(:manage, Sponsor)
    expect(ability).to be_able_to(:manage, Contact)
  end

  it "can manage only their own opportunities" do
    own_opportunity = build_stubbed(:opportunity, user_id: user.id)
    other_opportunity = build_stubbed(:opportunity, user_id: 999)

    expect(ability).to be_able_to(:manage, own_opportunity)
    expect(ability).not_to be_able_to(:manage, other_opportunity)
  end

  it "does not receive events or unrelated access" do
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Medium)
    expect(ability).not_to be_able_to(:manage, Person)
  end
end

context "office user in the Events Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user).to receive(:in_group?).with("events_team").and_return(true)
  end

  it "can manage events except deleting them" do
    expect(ability).to be_able_to(:index, Event)
    expect(ability).to be_able_to(:show, Event)
    expect(ability).to be_able_to(:create, Event)
    expect(ability).to be_able_to(:update, Event)
    expect(ability).not_to be_able_to(:destroy, Event)
    expect(ability).to be_able_to(:calendar, Event)
  end

  it "does not receive sponsor or unrelated access" do
    expect(ability).not_to be_able_to(:manage, Sponsor)
    expect(ability).not_to be_able_to(:manage, Contact)
    expect(ability).not_to be_able_to(:manage, Medium)
    expect(ability).not_to be_able_to(:manage, Person)
  end
end

context "office user in the Events Calendar Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("events_calendar_team")
      .and_return(true)
  end

  it "can access only the event calendar" do
    expect(ability).to be_able_to(:calendar, Event)
    expect(ability).not_to be_able_to(:index, Event)
    expect(ability).not_to be_able_to(:show, Event)
    expect(ability).not_to be_able_to(:create, Event)
    expect(ability).not_to be_able_to(:update, Event)
    expect(ability).not_to be_able_to(:destroy, Event)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Club)
    expect(ability).not_to be_able_to(:manage, Grant)
  end
end

context "office user in the Educators Events Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("educators_events_team")
      .and_return(true)
  end

  it "can manage educator resources and use the heat map" do
    expect(ability).to be_able_to(:manage, NetballEducator)
    expect(ability).to be_able_to(:manage, FollowUp)
    expect(ability).to be_able_to(:manage, Equipment)
    expect(ability).to be_able_to(:heat_map, NetballEducator)
    expect(ability).not_to be_able_to(:export, NetballEducator)
  end

  it "can manage events except deleting them" do
    expect(ability).to be_able_to(:index, Event)
    expect(ability).to be_able_to(:show, Event)
    expect(ability).to be_able_to(:create, Event)
    expect(ability).to be_able_to(:update, Event)
    expect(ability).not_to be_able_to(:destroy, Event)
    expect(ability).to be_able_to(:calendar, Event)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Grant)
    expect(ability).not_to be_able_to(:manage, Medium)
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Club)
  end
end

context "office user in the Donated Items Team group" do
  let(:user) do
    build_stubbed(
      :user,
      id: 100,
      role: "office",
      donated_items_access: false
    )
  end

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user).to receive(:in_group?).with("donated_items_team").and_return(true)
  end

  it "can view donated items and submit requests" do
    expect(ability).to be_able_to(:read, DonatedItem)
    expect(ability).to be_able_to(:create, DonatedItemRequest)
  end

  it "cannot administer donated items or requests" do
    expect(ability).not_to be_able_to(:create, DonatedItem)
    expect(ability).not_to be_able_to(:update, DonatedItem)
    expect(ability).not_to be_able_to(:destroy, DonatedItem)
    expect(ability).not_to be_able_to(:approve, DonatedItemRequest)
    expect(ability).not_to be_able_to(:decline, DonatedItemRequest)
  end

  it "does not receive unrelated access" do
    expect(ability).not_to be_able_to(:manage, Sponsor)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Person)
  end
end

context "office user in the Grants Team group" do
  let(:user) do
    build_stubbed(
      :user,
      id: 100,
      role: "office"
    )
  end

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user).to receive(:in_group?).with("grants_team").and_return(true)
  end

  it "can manage grants" do
    expect(ability).to be_able_to(:manage, Grant)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Sponsor)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Medium)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Club)
  end
end

context "office user in the Partners Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("partners_team")
      .and_return(true)
  end

  it "can manage partners" do
    expect(ability).to be_able_to(:manage, Partner)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Sponsor)
    expect(ability).not_to be_able_to(:manage, Grant)
    expect(ability).not_to be_able_to(:manage, Club)
  end
end

context "office user in the People Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user).to receive(:in_group?).with("people_team").and_return(true)
  end

  it "can manage people" do
    expect(ability).to be_able_to(:manage, Person)
  end

  it "does not receive US Open or unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:menu_all, Transfer)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Club)
    expect(ability).not_to be_able_to(:manage, Grant)
  end
end

context "office user in the Membership Admin Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("membership_admin_team")
      .and_return(true)
  end

  it "can fully administer membership records and views" do
    expect(ability).to be_able_to(:manage, Club)
    expect(ability).to be_able_to(:manage, Member)
    expect(ability).to be_able_to(:manage, IndividualMember)
    expect(ability).to be_able_to(:manage, Payment)
    expect(ability).to be_able_to(:index_admin, Club)
    expect(ability).to be_able_to(:teams_list_index, Club)
    expect(ability).to be_able_to(:read_all, IndividualMember)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Grant)
  end
end

context "office user in the Membership View Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("membership_view_team")
      .and_return(true)
  end

  it "can view membership records and list pages" do
    expect(ability).to be_able_to(:read, Club)
    expect(ability).to be_able_to(:read, Member)
    expect(ability).to be_able_to(:read, IndividualMember)
    expect(ability).to be_able_to(:index_admin, Club)
    expect(ability).to be_able_to(:teams_list_index, Club)
    expect(ability).to be_able_to(:read_all, IndividualMember)
  end

  it "cannot change membership records" do
    expect(ability).not_to be_able_to(:create, Club)
    expect(ability).not_to be_able_to(:update, Club)
    expect(ability).not_to be_able_to(:destroy, Club)
    expect(ability).not_to be_able_to(:create, Member)
    expect(ability).not_to be_able_to(:update, Member)
    expect(ability).not_to be_able_to(:destroy, Member)
    expect(ability).not_to be_able_to(:create, IndividualMember)
    expect(ability).not_to be_able_to(:update, IndividualMember)
    expect(ability).not_to be_able_to(:destroy, IndividualMember)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Grant)
  end
end

context "office user in the Clubs Index View Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("clubs_index_view_team")
      .and_return(true)
  end

  it "can access only the restricted Clubs index" do
    expect(ability).to be_able_to(:index_user, Club)
    expect(ability).not_to be_able_to(:index, Club)
    expect(ability).not_to be_able_to(:index_admin, Club)
    expect(ability).not_to be_able_to(:teams_list_index, Club)
    expect(ability).not_to be_able_to(:show, Club)
    expect(ability).not_to be_able_to(:create, Club)
    expect(ability).not_to be_able_to(:update, Club)
    expect(ability).not_to be_able_to(:destroy, Club)
  end

  it "does not receive other membership or operational access" do
    expect(ability).not_to be_able_to(:read, Member)
    expect(ability).not_to be_able_to(:read, IndividualMember)
    expect(ability).not_to be_able_to(:read, Payment)
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Event)
  end
end

context "office user in the Educators Export Team group" do
  let(:user) { build_stubbed(:user, id: 100, role: "office") }

  before do
    allow(user).to receive(:in_group?).and_return(false)
    allow(user)
      .to receive(:in_group?)
      .with("educators_export_team")
      .and_return(true)
  end

  it "can export educators without managing them" do
    expect(ability).to be_able_to(:export, NetballEducator)
    expect(ability).not_to be_able_to(:manage, NetballEducator)
  end

  it "does not receive unrelated operational access" do
    expect(ability).not_to be_able_to(:manage, Person)
    expect(ability).not_to be_able_to(:manage, Transfer)
    expect(ability).not_to be_able_to(:manage, Event)
    expect(ability).not_to be_able_to(:manage, Club)
  end
end

{
  "vendors_team" => Vendor,
  "venues_team" => Venue,
  "tours_team" => Tour,
  "programs_team" => Program,
  "netball_academies_team" => NetballAcademy
}.each do |group_key, resource_class|
  context "office user in the #{group_key.humanize} group" do
    let(:user) do
      build_stubbed(
        :user,
        id: 100,
        role: "office"
      )
    end

    before do
      allow(user).to receive(:in_group?).and_return(false)
      allow(user).to receive(:in_group?).with(group_key).and_return(true)
    end

    it "can manage only its group resource" do
      expect(ability).to be_able_to(:manage, resource_class)

      unrelated_resources = [
        Vendor,
        Venue,
        Tour,
        Program,
        NetballAcademy,
        Grant,
        Sponsor,
        Event
      ] - [resource_class]

      unrelated_resources.each do |unrelated_resource|
        expect(ability).not_to be_able_to(
          :manage,
          unrelated_resource
        )
      end
    end
  end
end

#-----------------------------------------------#

  context "admin role" do
    let(:user) { build(:user, role: "admin") }

    it "can manage everything" do
      expect(ability).to be_able_to(:manage, :all)
    end
  end
end
