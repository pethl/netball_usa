FactoryBot.define do
  factory :person do
    first_name { "John" }
    last_name { "Doe" }
    email { "john.doe@example.com" }
    role { "Scorer" }
  end
end

FactoryBot.define do
  factory :frequent_flyer_number do
    number { "12345" }
    airline { "delta" }
    association :person  # Ensure association is correct
  end
end