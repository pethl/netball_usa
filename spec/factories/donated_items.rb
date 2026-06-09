FactoryBot.define do
  factory :donated_item do
    description { "Amazon eGift Card" }
    item_type { "egift card" }
    value { 25 }
    requirements { "Use for volunteer recognition" }
    status { "Available" }
    donor_name { "Amazon Community Giving" }
    internal_notes { nil }
    expiry_date { nil }

    trait :requested do
      status { "Requested" }
    end

    trait :approved do
      status { "Approved" }
    end

    trait :expired do
      status { "Expired" }
      expiry_date { 1.month.ago.to_date }
    end

    trait :gift_basket do
      item_type { "gift basket" }
      description { "Volunteer Thank You Basket" }
      value { 75 }
    end

    trait :inventory_product do
      item_type { "inventory product" }
      description { "Netball USA Hoodie" }
      value { 45 }
    end
  end
end