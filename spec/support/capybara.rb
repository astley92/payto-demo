require "capybara/rspec"

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.around(:each, :skip_headless) do |example|
    Capybara.current_driver = :selenium_chrome
    Capybara.javascript_driver = :selenium_chrome
    example.call
    Capybara.use_default_driver
    Capybara.javascript_driver = :selenium_chrome_headless
  end
end
