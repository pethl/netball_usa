require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe "public access" do
    let(:user) { nil }
    subject(:ability) { Ability.new(user) }

    it "can create and show NetballEducator" do
      educator = build_stubbed(:netball_educator)

      # Debug: output ability and educator info
      puts "Ability rules:"
      puts ability.inspect
      puts "Educator instance:"
      puts educator.inspect

      expect(ability).to be_able_to(:create, educator)
      expect(ability).to be_able_to(:show, educator)
    end
  end
  

  describe "authenticated user with no role" do
    let(:user) { build(:user, role: nil, id: 1) }

    it "can read and update their own User record" do
      expect(ability).to be_able_to(:read, User.new(id: user.id))
      expect(ability).to be_able_to(:update, User.new(id: user.id))
    end

    it "cannot manage other users" do
      expect(ability).not_to be_able_to(:manage, User.new(id: 999))
    end
  end

  context "teams_grants role" do
    let(:user) { build(:user, role: "teams_grants") }

    it "can manage grant-related models" do
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
  end

  context "teamlead role" do
    let(:user) { build(:user, role: "teamlead", id: 1) }

    it "can manage own club and members" do
      expect(ability).to be_able_to(:manage, Club.new(user_id: user.id))
      expect(ability).to be_able_to(:manage, Member)
      expect(ability).to be_able_to(:manage, IndividualMember)
    end

    it "cannot manage other users" do
      expect(ability).not_to be_able_to(:manage, User.new(id: 999))
    end

    it "cannot manage events" do
      expect(ability).not_to be_able_to(:manage, Event)
    end
  end

  context "grants role" do
    let(:user) { build(:user, role: "grants") }

    it "can manage grants only" do
      expect(ability).to be_able_to(:manage, Grant)
      expect(ability).not_to be_able_to(:manage, Person)
    end
  end

  context "educators role" do
    let(:user) { build(:user, role: "educators") }

    it "can manage NetballEducator and FollowUp" do
      expect(ability).to be_able_to(:manage, NetballEducator)
      expect(ability).to be_able_to(:manage, FollowUp)
    end
  end

  context "teams_admin role" do
    let(:user) { build(:user, role: "teams_admin") }

    it "can manage all clubs and individual members" do
      expect(ability).to be_able_to(:manage, Club)
      expect(ability).to be_able_to(:manage, IndividualMember)
    end
  end

  context "sponsors_events role" do
    let(:user) { build(:user, role: "sponsors_events", id: 5) }

    it "can manage sponsors, contacts, own opportunities, and events" do
      expect(ability).to be_able_to(:manage, Sponsor)
      expect(ability).to be_able_to(:manage, Contact)
      expect(ability).to be_able_to(:manage, Opportunity.new(user_id: user.id))
      expect(ability).to be_able_to(:manage, Event)
    end
  end

  context "us_open role" do
    let(:user) { build(:user, role: "us_open") }

    it "can manage transfers and people" do
      expect(ability).to be_able_to(:manage, Transfer)
      expect(ability).to be_able_to(:manage, Person)
    end
  end

  context "educators_events role" do
    let(:user) { build(:user, role: "educators_events") }

    it "can manage NetballEducator, FollowUp, and Event" do
      expect(ability).to be_able_to(:manage, NetballEducator)
      expect(ability).to be_able_to(:manage, FollowUp)
      expect(ability).to be_able_to(:manage, Event)
    end
  end

  context "sponsors_media_events role" do
    let(:user) { build(:user, role: "sponsors_media_events", id: 6) }

    it "can manage sponsors, contacts, opportunities, media, and events" do
      expect(ability).to be_able_to(:manage, Sponsor)
      expect(ability).to be_able_to(:manage, Contact)
      expect(ability).to be_able_to(:manage, Opportunity.new(user_id: user.id))
      expect(ability).to be_able_to(:manage, Medium)
      expect(ability).to be_able_to(:manage, Event)
    end
  end

  context "educators_events_medium role" do
    let(:user) { build(:user, role: "educators_events_medium") }

    it "can manage educators, follow ups, events, and media" do
      expect(ability).to be_able_to(:manage, NetballEducator)
      expect(ability).to be_able_to(:manage, FollowUp)
      expect(ability).to be_able_to(:manage, Event)
      expect(ability).to be_able_to(:manage, Medium)
    end
  end

  context "spare role" do
    let(:user) { build(:user, role: "spare") }

    it "has no explicit permissions" do
      expect(ability).not_to be_able_to(:manage, Grant)
      expect(ability).not_to be_able_to(:manage, Event)
    end
  end

  context "na_people role" do
    let(:user) { build(:user, role: "na_people", email: "user@example.com") }
    let(:person) { build(:person, email: user.email, id: 10) }
    let(:transfer) { build(:transfer, person_id: person.id) }

    before do
      allow(Person).to receive(:find_by).with(email: user.email).and_return(person)
    end

    it "can read and update their own person record" do
      expect(ability).to be_able_to(:read, person)
      expect(ability).to be_able_to(:update, person)
    end

    it "cannot index people or transfers" do
      expect(ability).not_to be_able_to(:index, Person)
      expect(ability).not_to be_able_to(:index, Transfer)
    end

    it "can manage their own transfers" do
      expect(ability).to be_able_to(:read, transfer)
      expect(ability).to be_able_to(:create, transfer)
      expect(ability).to be_able_to(:update, transfer)
    end

    it "cannot delete people or events" do
      expect(ability).not_to be_able_to(:destroy, Person)
      expect(ability).not_to be_able_to(:destroy, Event)
    end
  end

  context "admin role" do
    let(:user) { build(:user, role: "admin") }

    it "can manage everything" do
      expect(ability).to be_able_to(:manage, :all)
    end
  end
end
