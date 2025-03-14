FactoryBot.define do
  factory :medium do
    media_type { "Podcasts" }
    company_name { "The Daily Times" }
    contact_name { "John Doe" }
    contact_position { "Editor" }
    email { "johndoe@example.com" }
    phone { "1234567890" }
    city { "New York" }
    state { "NY" }
    country { "USA" }
    pitch { "A great story idea!" }
    media_announcement_link { "https://news.com/article" }
    action_taken { "Followed up via email" }
    region_other { "North America" }
    company_website { "https://dailynews.com" }
    socials { "@dailynews" }
    notes { "Very responsive" }
    user { association :user } # Assuming you have a User factory
  end
end
