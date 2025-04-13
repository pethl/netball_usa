# factories/events.rb
FactoryBot.define do
  factory :event do
    event_type { "State Conference" }
    is_educational { "Yes" }
    name { "Netball Coaching Session" }
    status { "Prep" }
    attend { "TaggTime" }
    date { "2025-04-07" }
    end_date { "2025-04-08" }
    website { "https://example.com" }
    key_contact { "John Doe" }
    city { "New York" }
    state { "NY" }
    location { "Stadium A" }
    details { "Coaching session for coaches." }
    booth { "B1" }
    cost_notes { "Free for all participants." }
    outcome { "To be determined" }
   
    created_at { Time.now }
    updated_at { Time.now }
  end
end
