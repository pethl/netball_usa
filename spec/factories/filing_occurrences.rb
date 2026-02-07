# spec/factories/filing_occurrences.rb
FactoryBot.define do
  factory :filing_occurrence do
    filing
    due_date { Date.current }
    cost     { filing.cost }
    generated { true }
    filed     { false }
  end
end