FactoryBot.define do
  factory :event_transport do
    association :transfer_event, factory: :event
    departure_at { Time.zone.parse("2026-11-06 10:30") }
    arrival_at { Time.zone.parse("2026-11-06 10:45") }
    pickup_location { "Sunset Station Hotel" }
    destination { "American Heritage Academy" }
    driver_name { "Lisa" }
    notes { "Space required for equipment" }
  end

  factory :event_transport_passenger do
    association :event_transport
    association :person
  end
end
