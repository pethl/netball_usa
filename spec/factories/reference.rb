FactoryBot.define do
  factory :reference do
    group { "member_positions" }
    value { "Club President" }
    key   { "club_pres" }
    desc  { "The lead contact for the club" }
    active { true }
  end
end