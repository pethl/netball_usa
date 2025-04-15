FactoryBot.define do
  factory :program do
    program_stage { "Proposed" }
    program_name  { "Netball Youth Outreach" }
    na_program_contact_email { "contact@netball.org" }
    na_program_contact_phone { "555-123-4567" }
    location_name            { "Sunrise Middle School" }
    location_contact_phone   { "555-987-6543" }
    location_contact_email   { "school@edu.org" }
    address       { "123 Sport Ave" }
    city          { "Orlando" }
    state         { "FL" }
    zip           { "32801" }
    country       { "USA" }
    program_event_datetime { 1.month.from_now }
    timezone      { "Eastern" }
    funded_by     { "Youth Sports Grant" }
    notes         { "This will be a 3-week summer camp program." }

    # Associations
    association :person
  end
end
