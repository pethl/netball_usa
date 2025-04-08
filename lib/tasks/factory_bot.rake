# lib/tasks/factory_bot.rake

namespace :factory_bot do
  desc "Lint (test) all factories"
  task lint: :environment do
    FactoryBot.lint(traits: true, verbose: true)
  end
end
