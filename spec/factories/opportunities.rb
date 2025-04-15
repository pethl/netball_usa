FactoryBot.define do
  factory :opportunity do
    association :sponsor
    association :user

    status { "Not Started" }
    opportunity_type { "Cash" }
    website { "https://sponsor.com" }
    area { "U.S. Open" }
    pitch { "We would love to collaborate on youth events." }
    follow_up_actions { "Schedule a call next week." }
    notes { "Very engaged at the last event." }
    outcome { "Pending Response" }
    outcome_date { 1.week.from_now }
    outcome_received { "Basket full of goodies for Phoenix.Need to pick up from airport." }
    date_submitted { Date.today }
    in_progress_status { "Initial contact made" }
  end
end
