require 'rails_helper'

RSpec.describe Budget, type: :model do
  let(:event) { create(:event, name: "National Netball Conference", date: Date.new(2025, 7, 15)) }
  let(:budget) { create(:budget, event: event) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(budget).to be_valid
    end

    it "is not valid without an event" do
      budget.event_id = nil
      expect(budget).not_to be_valid
    end
  end

  describe "#per_diem_total" do
    it "calculates the total per diem correctly" do
      expected_total = budget.per_diem * budget.number_of_people * budget.number_of_days
      expect(budget.per_diem_total).to eq(expected_total)
    end
  end

  describe "#budget_total" do
    it "sums all budget fields and per diem total" do
      expected = budget.flight.to_f +
                 budget.hotel.to_f +
                 budget.transport.to_f +
                 budget.shipping.to_f +
                 budget.booth.to_f +
                 budget.carpet.to_f +
                 budget.banners.to_f +
                 budget.giveaways.to_f +
                 budget.per_diem_total.to_f
      expect(budget.budget_total).to eq(expected)
    end
  end

  describe "#budget_event_name" do
    it "returns the event name" do
      expect(budget.budget_event_name).to eq("National Netball Conference")
    end
  end

  describe "#budget_event_date" do
    it "returns the formatted event date" do
      expect(budget.budget_event_date).to eq("Jul 15, 2025")

    end
  end
end
