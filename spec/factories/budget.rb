FactoryBot.define do
  factory :budget do
    association :event

    flight       { 550.75 }
    flight_notes { "Economy class round trip with 1 bag included" }

    hotel        { 1250.00 }
    hotel_notes  { "4 nights at 4-star downtown hotel" }

    transport        { 325.50 }
    transport_notes  { "Airport pickup + local travel (Uber/Lyft)" }

    shipping       { 180.00 }
    shipping_notes { "Event materials and gear sent via FedEx" }

    booth       { 400.00 }
    booth_notes { "10x10 booth at conference expo" }

    carpet       { 120.00 }
    carpet_notes { "Custom printed floor vinyl" }

    banners       { 160.00 }
    banner_notes  { "Pop-up banners x2 and table cover" }

    giveaways       { 275.00 }
    giveaway_notes  { "Reusable water bottles and keychains" }

    per_diem         { 60.00 }
    number_of_people { 5 }
    number_of_days   { 3 }
  end
end
