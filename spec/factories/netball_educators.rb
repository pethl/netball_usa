# spec/factories/netball_educators.rb
FactoryBot.define do
  factory :netball_educator do
    first_name { "Jane" }
    last_name  { "Doe" }
    sequence(:email) { |n| "educator#{n}@example.com" }
    phone { "555-555-5555" }
    title { "Elem PE Teacher"}
    school_name { "Test Academy" }
    address { "123 School Street" }
    city { "Miami" }
    state { "FL" }
    zip { "33101" }
    website { "http://testacademy.edu" }
    level { "High School" } # or "Elementary", "Middle School", etc depending on your list
    educator_notes { "Interested in new programs" }
    feedback { "Great session!" }
    authorize { true }
    mgmt_notes { "High potential" }
    is_pe_director { false}
    user # assumes you have a user factory too
  end
end
