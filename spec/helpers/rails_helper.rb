# spec/rails_helper.rb
RSpec.configure do |config|
    # Include Devise test helpers in controller specs
    config.include Devise::Test::ControllerHelpers, type: :controller
  end