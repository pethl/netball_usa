FactoryBot.define do
  factory :event_participant do
    association :event

    # Don’t assign person or netball_educator by default,
    # because we want to control that in each test
  end
end