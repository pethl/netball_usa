# spec/factories/individual_members.rb
FactoryBot.define do
  factory :individual_member do
    association :user   # assumes model has `belongs_to :user`
    association :club   # <-- adding this based on your schema

    membership_type { "Individual" }
    first_name { "Handy" }
    last_name { "Man" }
    email { "handy.man@example.com" }
    phone { "0400000000" }
    address { "123 Main St" }
    city { "Suburbia" }
    state { "FL" }
    country { "USA" }
    zip { "1234" }
    gender { "Female" }
    age_status { "Adult" }
    engagement_status { "Active" }
    
    # Added missing fields (with safe defaults):
    interested_in_coaching { false }
    interested_in_umpiring { false }
    interested_in_usa_team { false }
    place_of_birth { "Sample City, USA" }
    notes { "Some notes about the individual member." }
    renewal_years { "2024" }
    renewal_response { "yes" }
    
    # Optional associations
    # team_id is left nil unless needed
  end
end

