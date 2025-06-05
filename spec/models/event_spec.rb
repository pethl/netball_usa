# spec/models/event_spec.rb
require "rails_helper"

RSpec.describe Event, type: :model do
  let(:event) { create(:event, date: Date.today, is_educational: "Yes", name: "Netball 101", event_type: "Training") }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(event).to be_valid
    end

    it "is not valid without a name" do
      event.name = nil
      expect(event).not_to be_valid
    end

    it "is not valid without an event_type" do
      event.event_type = nil
      expect(event).not_to be_valid
    end
  end

  describe "associations" do
    it { should have_many(:event_participants).dependent(:destroy) }
    it { should have_many(:people).through(:event_participants) }
    it { should have_many(:netball_educators).through(:event_participants) }
    it { should have_many(:event_assignments).dependent(:destroy) }
    it { should have_many(:transfers) }
    it { should have_one(:budget) }
  end

  describe "scopes" do
    before do
      create(:event, date: 1.month.ago, is_educational: "No")
      create(:event, date: 2.months.from_now, is_educational: "Yes")
    end

    it "returns events ordered by date ascending" do
      expect(Event.ordered.pluck(:date)).to eq(Event.order(date: :asc).pluck(:date))
    end

    it "returns only educational events" do
      expect(Event.educational.pluck(:is_educational).uniq).to eq(["Yes"])
    end

    it "returns upcoming events from current month onward" do
      upcoming = Event.upcoming
      expect(upcoming.all? { |e| e.date >= Date.today.beginning_of_month }).to be true
    end

    it "returns past events before current month" do
      past = Event.past
      expect(past.all? { |e| e.date < Date.today.beginning_of_month }).to be true
    end

    it "returns gone events before today" do
      gone = Event.gone
      expect(gone.all? { |e| e.date < Date.today }).to be true
    end
  end

  describe "instance methods" do
    it "#event_date_formatted returns date formatted as :usa" do
      expect(event.event_date_formatted).to eq(event.date.to_formatted_s(:usa))
    end

    it "#event_date_name returns formatted date and name" do
      expect(event.event_date_name).to eq("#{event.event_date_formatted}, #{event.name} ")
    end

    it "#event_date_type_name returns formatted date, type, and name" do
      expect(event.event_date_type_name).to eq("#{event.event_date_formatted}, #{event.event_type}:  #{event.name} ")
    end

    it "#event_date_year returns the year of the event date" do
      expect(event.event_date_year).to eq(event.date.year)
    end

    it "#event_date_year returns 'Dates TBD' if date is nil" do
      event.date = nil
      expect(event.event_date_year).to eq("Dates TBD")
    end

    describe "#budget_count" do
      it "returns 0 if no budget exists for the event" do
        expect(event.budget_count).to eq(0)
      end

      it "returns budget records if present" do
        budget = create(:budget, event_id: event.id)
        expect(event.budget_count).to eq([budget])
      end
    end

    describe "assignment and email" do
      include ActiveJob::TestHelper
    
      let(:assigner) { create(:user, first_name: "Lisa") }
      let(:assignee) { create(:user, first_name: "Nathalie") }
      let!(:event) { create(:event, assigned_user: nil) }
    
      before do
        Current.user = assigner
        ActionMailer::Base.deliveries.clear
      end
    
      after do
        clear_enqueued_jobs
        clear_performed_jobs
        Current.user = nil
      end
    
      it "assigns a user and sends an email" do
        perform_enqueued_jobs do
          event.update!(assigned_user: assignee)
        end
      
        matching_emails = ActionMailer::Base.deliveries.select do |mail|
          mail.to.include?(assignee.email) && mail.subject.match?(/assigned a new event/i)
        end
      
        expect(matching_emails.size).to eq(1)
        mail = matching_emails.first
        expect(mail.body.encoded).to include(event.name)
      end
    
      it "does not send email when assigned to self" do
        expect {
          perform_enqueued_jobs do
            event.update!(assigned_user: assigner)
          end
        }.not_to change { ActionMailer::Base.deliveries.count }
    
        expect(event.reload.assigned_user).to eq(assigner)
      end
    end
  end
end

