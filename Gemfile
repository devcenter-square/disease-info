source 'https://rubygems.org'
ruby '3.2.10'

# Bundle gems for development with the command below.
# bundle install --without production

gem 'rails', '~> 7.1.0'
gem 'nokogiri', '>= 1.19.1'
gem 'rack-cors', :require => 'rack/cors'
gem 'jbuilder', '~> 2.11'
gem 'responders', '~> 3.0'

group :development, :test do
  gem 'pry'
  gem 'sqlite3', '~> 1.5.0'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 6.0'
  gem 'rails-controller-testing'
  gem 'factory_bot_rails'
  gem 'database_cleaner-active_record'
  gem 'faker'
end

group :test do
  gem 'webmock'
  gem 'simplecov', require: false
  gem 'vcr'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'spring'
end

group :production do
  gem "pg", "~> 1.2"
  gem "rails_12factor"
end

