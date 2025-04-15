FactoryBot.define do
  factory :club do
    name { "Texas Longhorns" }
    city { "Austin" }
    us_state { "TX" }
    membership_category { "1 Team - 8-13 Active Members" }
    website { "https://example.com" }
    facebook { "https://facebook.com/exampleclub" }
    twitter { "https://twitter.com/exampleclub" }
    instagram { "https://instagram.com/exampleclub" }
    other_sm { "Other social media links here" }
    estimate_total_number_of_club_members { 13 }
    estimate_total_active_members { 12 }
    estimate_total_part_time_members { 1 }
    renewal_years { "2024" }
    renewal_response { "yes" }
    
    # Associations
    association :creator, factory: :user

    # By default created_at/updated_at handled by Rails
  end
end
