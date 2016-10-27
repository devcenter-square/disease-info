source 'https://rubygems.org'
ruby '2.3.1'

# Bundle gems for development with the command below.
# bundle install --without production

gem 'rails', '4.2.5.1'
gem 'rack-cors', :require => 'rack/cors'
gem 'jbuilder', '~> 2.0'
gem 'responders', '~> 2.0'
gem 'jbuilder-prettify', '~> 0.0.1'

group :development, :test do
  gem 'pry'
  gem 'sqlite3'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.5'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'faker'
  gem 'spec_writer'
end

group :test do
  gem 'webmock'
  gem 'simplecov', require: false
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
end

group :production do
  gem "pg", "~> 0.15"
  gem "rails_12factor"
end

