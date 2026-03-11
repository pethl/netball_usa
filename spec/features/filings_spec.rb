# spec/features/filings_spec.rb
require "rails_helper"

RSpec.describe "Filings Management", type: :feature, js: true do
  let(:admin_user) { create(:user, :admin) }

  before do
    login_as(admin_user, scope: :user)
  end

  scenario "admin creates a filing and a year of occurrences is generated" do
    visit new_filing_path

    fill_in "filing_corporate_name", with: "Acme Corp"
    select "monthly", from: "filing_frequency"
    fill_in "filing_day_of_month", with: "15"
    fill_in "filing_cost", with: "25.00"
    fill_in "filing_start_date", with: Date.current.beginning_of_month

    click_button "Save Record"

    filing = Filing.find_by(corporate_name: "Acme Corp")
    expect(filing).to be_present

    occurrences = filing.filing_occurrences
    expect(occurrences.count).to be >= 12
    expect(occurrences.pluck(:generated).uniq).to eq([true])
  end

  scenario "admin edits a filing cost and future occurrences update" do
    filing = create(:filing, cost: 25.00)

    FilingOccurrenceGenerator.generate_from_start(filing)

    visit edit_filing_path(filing)

    fill_in "filing_cost", with: "30.00"
    click_button "Save"

    future_occurrences =
      filing.filing_occurrences.where("due_date >= ?", Date.current)

    expect(future_occurrences.pluck(:cost).uniq).to eq([30.00])
  end

  scenario "admin marks a filing inactive" do
    filing = create(:filing)

    visit edit_filing_path(filing)

    uncheck "filing_active"
    click_button "Save"

    filing.reload

    expect(filing.active).to be false
    expect(filing.paused_at).to be_present
  end

  scenario "admin generates another year of occurrences" do
    filing = create(:filing)

    FilingOccurrenceGenerator.generate_from_start(filing)

    initial_max_date =
      filing.filing_occurrences.maximum(:due_date)

    visit filing_path(filing)

    click_button "Generate Another Year of Payments Due"

    filing.reload

    new_max_date =
      filing.filing_occurrences.maximum(:due_date)

    expect(new_max_date).to be > initial_max_date
  end
end
