# spec/factories/payments.rb
FactoryBot.define do
  factory :payment do
    payment_year { Date.today.year }
    payment_type { "Zelle" }
    payment_received_date { Date.today }
    payment_transaction_reference { "TXN123456" }
    amount { 90.00 }
    payment_notes { "Payment sent via HQ." }

    association :payment_recorded_by, factory: :user

    # Traits
    trait :club_payment do
      individual_member { nil }
      club { create(:club) }  # 👈 manually create and set club
    end
    

    trait :individual_payment do
      club { nil }
      individual_member { create(:individual_member) }
    end
  end
end
