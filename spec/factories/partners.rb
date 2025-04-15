FactoryBot.define do
  factory :partner do
    company                  { "Community Connect Co." }
    description              { "Collaborates on youth engagement projects." }
    location                 { "123 Collaboration Blvd" }
    city                     { "San Diego" }
    us_state                 { "CA" }
    country                  { "USA" }
    website                  { "https://communityconnect.org" }
    date_initially_connected { 2.months.ago }
    date_pitch_to_na        { 1.month.ago }
    date_pitch_by_na        { 3.weeks.ago }
    pitch_to_na             { "Pitch sent regarding joint program funding." }
    pitch_by_na             { "Outlined our mutual program value." }
    follow_up_action        { "Schedule call in 2 weeks." }
    partnership_agreement   { "Draft in progress." }
    accept_partnership      { "Accept" }
    date_of_decision        { 1.week.from_now }

    # Primary Contact
    first_name_primary       { "Jane" }
    last_name_primary        { "Smith" }
    role_primary             { "Director" }
    email_primary            { "jane@partner.org" }
    cell_primary             { "555-111-2222" }
    work_phone_primary       { "555-333-4444" }

    # Optional Secondary Contact
    first_name_secondary     { "Bob" }
    last_name_secondary      { "Jones" }
    role_secondary           { "Coordinator" }
    email_secondary          { "bob@partner.org" }
    cell_secondary           { "555-555-1234" }
    work_phone_secondary     { "555-555-9876" }

    # Optional Third Contact
    first_name_third         { "Ana" }
    last_name_third          { "Lopez" }
    role_third               { "Volunteer Lead" }
    email_third              { "ana@partner.org" }
    cell_third               { "555-777-8888" }
    work_phone_third         { "555-777-9999" }

    association :user
  end
end
