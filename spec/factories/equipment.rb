# spec/factories/equipment.rb
FactoryBot.define do
  factory :equipment do
    sale_date { "2025-02-02 00:00:00" }
    items_purchased  { "2 nets, 2 balls, set of bibs" }
    purchase_amount { 50 }
    association :netball_educator
  end
end
