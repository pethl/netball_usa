FactoryBot.define do
  factory :member do
    first_name { "Brie" }
    last_name { "Larson" }
    sequence(:email) { |n| "brie.larson#{n}@example.com" }
    city { "Austin" }
    state { "TX" }
    gender { "Female" }
    age_status { "Adult" }
    engagement_status { "Active" }
    interested_in_coaching { false }
    interested_in_umpiring { false }
    interested_in_usa_team { true }
    dob { 30.years.ago }
    place_of_birth { "Austin, TX" }
    notes { "Friend of Sonya, wife of John." }
    phone { "123-456-7890" }
    address { "123 Sample Street" }
    zip { "12345" }
    
    # Associations
    association :club
    # Optional association if needed later: team
    # association :team


    trait :youth do
      age_status { "Youth" }
    end
    
    trait :part_time do
      engagement_status { "Part-Time" }
    end
    
    trait :with_team do
      association :team
    end
    
  end
end
