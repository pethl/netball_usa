require "rails_helper"

RSpec.describe "Events calendar", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { create(:user, :admin) }

  before do
    sign_in admin
  end

  it "filters the calendar by event type and preserves the filter between years" do
    selected_event = create(
      :event,
      name: "Selected calendar event",
      event_type: "Festival",
      date: Date.new(Date.current.year, 6, 10)
    )
    create(
      :event,
      name: "Excluded calendar event",
      event_type: "State Conference",
      date: selected_event.date
    )

    get calendar_events_path(event_type: "Festival")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Selected calendar event")
    expect(response.body).not_to include("Excluded calendar event")

    document = Nokogiri::HTML(response.body)
    year_links = document.css("a[href*='/events/calendar'][href*='year=']")

    expect(year_links.size).to eq(2)
    expect(year_links).to all(
      satisfy { |link| link["href"].include?("event_type=Festival") }
    )
  end
end
