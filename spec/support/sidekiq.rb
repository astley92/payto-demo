require "sidekiq/testing"

RSpec.configure do |config|
  config.around(:each, :inline_jobs) do |example|
    Sidekiq::Testing.inline!
    example.call
    Sidekiq::Testing.fake!
  end
end
