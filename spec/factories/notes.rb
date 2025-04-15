FactoryBot.define do
  factory :note do
    body { "Based in Westport/Stamford/Westchester.  Zip code 06880" }
    status { "Not Started" }
    association :club
  end
end
