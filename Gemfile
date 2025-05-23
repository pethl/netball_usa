source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.3'


# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '7.1.5'
gem 'concurrent-ruby', '1.3.4'

gem 'paper_trail' #audit

# setting to get around upgrade error 337
#gem 'activesupport', '7.0.8'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 6.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "~> 1.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

# sendgrid email
#gem 'sendgrid-ruby'

#devise
gem "devise", github: 'heartcombo/devise', branch: 'main' 
  gem "phonelib"


# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 6.1.0'
  gem 'capybara'
  gem 'selenium-webdriver' # for browser testing
  gem 'webdrivers' 
  gem 'factory_bot_rails'
  gem 'annotate'
  gem 'database_cleaner-active_record'
  
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  gem "letter_opener_web"
  gem 'spring'
  gem 'spring-commands-rspec'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  gem 'shoulda-matchers', '~> 5.0'  
  gem 'simplecov', require: false

end

group :production do
  gem "aws-sdk-s3", "~> 1.14"
end

# file uploader
gem "shrine", "~> 3.0"

# PDF generator
gem 'prawn', '~> 2.5'
gem 'prawn-table', '~> 0.1.0'
gem 'thor', '~> 1.2.0'


gem "cancancan", "~> 3.5"
gem 'bootstrap-datepicker-rails'
gem 'htmlbeautifier'
gem 'mail', '~> 2.7'

# required after 3.3.4 upgrade, may be able to remove eventuallybu
gem 'base64', '~> 0.2.0'
gem 'mutex_m', '~> 0.2.0'

# required for excel export
gem 'rubyzip', '>= 2.3.0'
gem 'caxlsx'
gem 'caxlsx_rails'
gem "capybara-email", "~> 3.0", group: :test

gem 'pagy', '~> 9.3'

