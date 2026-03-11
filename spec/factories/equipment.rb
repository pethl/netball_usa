FactoryBot.define do
  factory :equipment do
    status { "Quote" }
    association :netball_educator

    trait :quote do
      status { "Quote" }
      customer_name { "Jane Smith" }
      customer_email { "jane@example.com" }
      customer_address { "123 Main St" }
      items_quoted { "2 nets, 2 balls, set of bibs" }
      quote_amount { 75.0 }
    end

    trait :sale do
      status { "Sale" }
      sale_date { Date.new(2025, 2, 2) }
      items_purchased { "2 nets, 2 balls, set of bibs" }
      purchase_amount { 50.0 }
    end

    trait :without_educator do
      netball_educator { nil }
    end
  end
end