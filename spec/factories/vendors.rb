FactoryBot.define do
  factory :vendor do
    company_name   { "PrintCo Solutions" }
    contact_name   { "Samantha Lee" }
    sequence(:email) { |n| "samantha#{n}@printco.com" }
    phone          { "555-123-4567" }
    website        { "https://printco.com" }
    notes          { "Offers discounts for bulk orders. Known for reliable turnaround." }

    # Optional trait if you need a vendor with references
    trait :with_references do
      after(:create) do |vendor|
        reference = create(:reference, group: "vendor_category", value: "Flyers")
        create(:reference_vendor, vendor: vendor, reference: reference)
      end
    end
  end
end

