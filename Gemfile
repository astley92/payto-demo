source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"

gem "activerecord-postgres_enum"
gem "active_interaction", "~> 5.2"
gem "bootsnap", require: false
gem "faraday"
gem "figaro"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.4", ">= 7.0.4.2"
gem "redis", "~> 4.0"
gem "sidekiq"
gem "simple_form"
gem "slim"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

group :development, :test do
  gem "annotate"
  gem "byebug"
  gem "capybara"
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "selenium-webdriver"
  gem "vcr"
end

group :development do
  gem "web-console"
end
