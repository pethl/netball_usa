FactoryBot.define do
  factory :open_invite do
    status { "MyString" }
    invite_sent { false }
    invite_sent_date { "2025-03-22" }
    rspv { false }
    whova { false }
    flight_booked { false }
    sent_save_the_date { false }
    response_to_save_the_date { false }
    send_official_invite { false }
    comments { "MyText" }
    people { nil }
  end
end
