# spec/factories/individual_members.rb
FactoryBot.define do
  factory :individual_member do
    association :user  # assumes your model has `belongs_to :user`

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
  end
end
