 # spec/factories/users.rb

 FactoryBot.define do
    factory :user do
      first_name { "Handy" }
      last_name { "Man" }
      email { "test@example.com" }
      password { "password123" }
      password_confirmation { "password123" }
      role { "admin" }
      admin { true }
      # Add other necessary attributes for your User model
    end
  end