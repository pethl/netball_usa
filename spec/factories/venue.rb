FactoryBot.define do
  factory :venue do
    facility_type { "Indoor Sports Complex" }
    venue_name { "Sunset Netball Arena" }
    street { "123 Court Ave" }
    city { "Orlando" }
    state { "FL" }
    zip { "32801" }
    website { "https://sunsetarena.com" }
    contact_name { "Jamie Coach" }
    phone { "555-123-4567" }
    email { "contact@sunsetarena.com" }
    permit_application_link { "https://permits.orlando.gov" }
    grant_information_link { "https://grants.sportusa.org" }
    number_of_courts { "3" }
    size_of_courts { "Standard" }
    retractable_basketball_hoops { "Yes" }
    space_from_courts_to_wall { "15 feet" }
    seating_available { "Bleachers - 150 seats" }
    restaurant_onsite { "Cafe with hot and cold meals" }
    facilities_close_by { "Pharmacy, Grocery Store, Hotel" }
    locker_rooms_onsite { "Yes" }
    pool { "Yes" }
    hot_tub { "No" }
    bed_types { "Queen, Twin Bunk" }
    cost_per_hour { 50.00 }
    cost_per_day { 400.00 }
    cost_per_night { 120.00 }
    notes { "Open year-round. Book at least 2 weeks in advance." }
    role { "Primary Facility Partner" }
  end
end

