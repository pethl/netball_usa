FactoryBot.define do
  factory :donated_item_request do
    association :donated_item
    association :requested_by, factory: :user

    purpose { "Volunteer recognition prize" }
    recipient_name { "Jane Smith" }
    recipient_phone { "555-123-4567" }

    delivery_method { "Email" }
    delivery_email { "jane@example.com" }

    delivery_name { nil }
    delivery_address { nil }

    date_needed_by { 2.weeks.from_now.to_date }

    status { "Pending" }

    approved_by { nil }
    approved_at { nil }

    trait :approved do
      status { "Approved" }
      association :approved_by, factory: :user
      approved_at { Time.current }
    end

    trait :declined do
      status { "Declined" }
      association :approved_by, factory: :user
      approved_at { Time.current }
    end

    trait :mail_delivery do
      delivery_method { "Mail" }
      delivery_name { "Jane Smith" }
      delivery_address { "123 Main Street\nDenver, CO 80202" }
      delivery_email { nil }
    end
  end
end