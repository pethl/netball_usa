ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

if Rails.env.production?
  puts "🚨 ABORTING: Rails is running in production mode! 🚨"
  exit(1)
end

require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/email/rspec'

# Load support files
Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# === RSpec Configuration ===
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.include AuthHelpers, type: :feature
  config.include FormHelpers, type: :feature

  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.fixture_paths = ["#{::Rails.root}/spec/fixtures"]
  config.global_fixtures = :all

  config.include ActiveJob::TestHelper
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :feature
  config.include Warden::Test::Helpers

  config.after :each do
    Warden.test_reset!
  end

  # ✅ Transactional fixtures will wrap each test in a database transaction
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Shoulda Matchers
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :active_record
      with.library :active_model
      with.library :action_controller
    end
  end
end

# === Capybara Configuration ===
Capybara.register_driver :selenium_firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end
Capybara.javascript_driver = :selenium_firefox

# === Check for pending migrations ===
begin
  ActiveRecord::Migration.check_all_pending! # Only check, don't purge/reset
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end
