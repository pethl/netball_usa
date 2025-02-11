 # spec/factories/users.rb

 FactoryBot.define do
    factory :user do
      email { "test@example.com" }
      password { "password123" }
      # Add other necessary attributes for your User model
    end
  end