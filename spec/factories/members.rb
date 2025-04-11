FactoryBot.define do
  factory :member do
    first_name { "Brie" }
    last_name { "Larson" }
    email { "brie.larson@example.com" }
    city { "Austin" }
    state { "Texas" }
    gender { "Female" }
    interested_in_coaching { false }
    interested_in_umpiring { false }
    interested_in_usa_team { true }
    dob { 30.years.ago }
    place_of_birth { "Austin, TX" }
    notes { "Friend of Sonya, wife of John." }
    age_status { "Adult" } # or "Youth" depending on test needs
    engagement_status { "Active" } # or "Part-Time"
   # membership_type { "Player" } field not needed
    phone { "123-456-7890" }
    address { "123 Sample Street" }
    zip { "12345" }
    
    # Associations
    association :club
    # Optional association if needed later: team
    # association :team

    # na_team_id left nil unless you really need it for a test
  end
end
