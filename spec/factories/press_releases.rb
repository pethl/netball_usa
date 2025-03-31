FactoryBot.define do
  factory :press_release do
    media_announcement_link { "MyString" }
    release_date { "2025-03-31" }
    title { "MyString" }
    content { "MyText" }
    medium { nil }
  end
end
