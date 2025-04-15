FactoryBot.define do
  factory :member_key_role do
    key_role { "Club President" }
    member_id { create(:member).id }
    association :club

    trait :club_president do
      key_role { "Club President" }
    end

    trait :head_coach do
      key_role { "Head Coach" }
    end

    trait :head_umpire do
      key_role { "Head Umpire" }
    end

    trait :club_key_contact do
      key_role { "Club Key Contact" }
    end
  end
end
