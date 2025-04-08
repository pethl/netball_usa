FactoryBot.define do
  factory :medium do
    media_type { "Podcasts" }
    company_name { "The Daily Times" }
    contact_name { "John Doe" }
    contact_email { "johnny@dt.com" }
    contact_position { "Editor" }
    email { "johndoe@example.com" }
    phone { "1234567890" }
    city { "New York" }
    state { "NY" }
    country { "USA" }
    pitch { "A great story idea!" }
 #   media_announcement_link { "https://news.com/article" }
 #   release_date { "2021-01-01" }
 #   socials { "@dailynews" }
    action_taken { "Followed up via email" }
    region_other { "North America" }
    company_website { "https://dailynews.com" }
    facebook { "@dailynews" }
    instagram { "@dailynews" }
    twitter { "@dailynews" }
    event_calender_link { "https://eventcalendar.com/dailynews" }
    calendar_login_details { "username: dailynews, password: dailynews" }
    notes { "Very responsive" }
    old_user_id { 1 }
    user { association :user } # Assuming you have a User factory
  end
end
