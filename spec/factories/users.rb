 # spec/factories/users.rb

 FactoryBot.define do
    factory :user do
      first_name { "Handy" }
      last_name { "Man" }
      sequence(:email) { |n| "user#{n}@example.com" }
      password { "password123" }
      password_confirmation { "password123" }
      role { "teamlead" } # Default role if you don't specify one
      admin { false }
      # Add other necessary attributes for your User model
    end
  end