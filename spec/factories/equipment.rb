# spec/factories/equipment.rb
FactoryBot.define do
  factory :equipment do
    sale_date { "2025-02-02 00:00:00" }
    items_purchased { "2 nets, 2 balls, set of bibs" }
    purchase_amount { 50 }
    status { "Quote" }

    association :netball_educator

    trait :quote do
      status { "Quote" }
    end

    trait :sale do
      status { "Sale" }
    end

    trait :without_educator do
      netball_educator { nil }
    end
  end
end
