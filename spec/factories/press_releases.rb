FactoryBot.define do
  factory :press_release do
    media_announcement_link { "https://www.google.com" }
    release_date { "2025-03-31" }
    title { "MyString" }
    content { "MyText" }
    association :medium
  end
end
