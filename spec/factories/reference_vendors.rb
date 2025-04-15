FactoryBot.define do
  factory :reference_vendor do
    association :vendor
    association :reference
  end
end

