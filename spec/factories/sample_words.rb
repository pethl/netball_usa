# spec/factories/sample_words.rb
FactoryBot.define do
  factory :sample_word do
    category { "Inspiration" }
    title { "Empower" }
    desc { "A word meant to inspire confidence and action." }
  end
end