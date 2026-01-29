 # spec/factories/users.rb

 FactoryBot.define do
  factory :user do
    first_name { "Handy" }
    last_name  { "Man" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }
    account_active { true }

    role { :teamlead }   # ✅ enum symbol
    admin { false }

    trait :grant_user do
      role { :grants }   # enum value 3
    end

    trait :admin do
      role { :admin }    # enum value 0
      admin { true }     # keep if app expects it elsewhere
    end
  end
end
