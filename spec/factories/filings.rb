# spec/factories/filings.rb
FactoryBot.define do
  factory :filing do
    corporate_name { "Test Filing Inc" }
    filing_type    { "Tax" }
    frequency      { "monthly" }
    start_date     { Date.current.beginning_of_month }
    day_of_month   { 15 }
    cost           { 25.00 }
    active         { true }
    created_by     { association :user, :admin }
  end
end