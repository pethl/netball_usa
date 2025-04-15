FactoryBot.define do
  factory :transfer do
    association :person
    association :event

    role { "Scorer" }
    check_in { Date.new(2024, 11, 5) }
    check_out { Date.new(2024, 11, 7) }

    # Optional file attachments if you're testing uploads:
    # headshot { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test.jpg"), "image/jpeg") }
    # certification { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test.pdf"), "application/pdf") }

    # You can also add traits for edge cases if needed later:
    trait :invalid_dates do
      check_in { Date.today }
      check_out { Date.yesterday }
    end
  end
end
