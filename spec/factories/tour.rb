FactoryBot.define do
  factory :tour do
    company { "Global Youth Tours" }
    description { "Provides educational and sports tours." }
    location { "Main Campus" }
    city { "Orlando" }
    us_state { "FL" }
    website { "https://globalyouthtours.com" }
    date_initially_connected { 3.weeks.ago }
    date_pitch_to_na { 2.weeks.ago }
    date_pitch_by_na { 1.week.ago }
    pitch_to_na { "Exciting partnership potential" }
    pitch_by_na { "Ready to collaborate" }
    follow_up_action { "Send agreement draft" }
    tour_agreement { "Pending review" }
    accept_tour { "Accept" }
    date_of_decision { 1.day.ago }

    first_name_primary { "Ava" }
    last_name_primary { "Smith" }
    role_primary { "Director" }
    email_primary { "ava@example.com" }
    cell_primary { "123-456-7890" }
    work_phone_primary { "987-654-3210" }

    first_name_secondary { "" }
    last_name_secondary { "" }
    role_secondary { "" }
    email_secondary { "" }
    cell_secondary { "" }
    work_phone_secondary { "" }

    first_name_third { "" }
    last_name_third { "" }
    role_third { "" }
    email_third { "" }
    cell_third { "" }
    work_phone_third { "" }
  end
end
