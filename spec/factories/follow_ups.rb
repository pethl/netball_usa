# spec/factories/follow_ups.rb
FactoryBot.define do
  factory :follow_up do
    lead_type {"Workshop"}  
    status {"In Progress"}
    action_items {"Confirm dates with teacher."}
    sale_amount {50}
    add_to_mailing_list {true}
    association :netball_educator
    association :user
    association :event
  end
end