FactoryBot.define do
  factory :contact do
    first_name { "Jane" }
    last_name  { "Smith" }
    prefix { "Ms." }
    suffix { "MBA" }
    nickname { "Janie" }
    email { "jane.smith@example.com" }
    phone { "555-123-4567" }
    mobile { "555-987-6543" }
    linked_in { "https://www.linkedin.com/in/janesmith" }
    job_title { "Community Manager" }
    department { "Partnerships" }
    organisation { "Netball USA" }
    location { "New York Office" }
    notes { "Met at annual summit, interested in collaboration." }

    association :sponsor
    # Uncomment if using partner_id later
    # association :partner
  end
end
