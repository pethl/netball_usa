FactoryBot.define do
  factory :grant do
    association :user
    name { "Women's Sports Foundation - Travel & Training Grant" }
    apply { true }
    grant_type { "Cash" }
    amount { 5000 }
    location { "national" }
    state { "NY" }
    due_date { "2024-06-20T17:00:00.000Z" }
    timezone { "Eastern" }
    purpose { "Travel & Training" }
    grant_link { "https://www.womenssportsfoundation.org/grant-opportunities/travel-training-grants" }
    status { "In Progress" }
    action_by { "2024-06-20T17:00:00.000Z" }
    date_submitted { "2024-06-20T17:00:00.000Z" }
    program { "BAI Southern California" }
    application_link { "https://www.womenssportsfoundation.org/grant-opportunities/travel-training-grants" }
    login { "https://www.womenssportsfoundation.org/grant-opportunities/travel-training-grants" }
    notification_date { "2024-06-20T17:00:00.000Z" }
    inkind_description {"words of a description here"}
    notes { "This is a test note make this a longer note words here more words here and some more things to say here" }
   
  end
end
