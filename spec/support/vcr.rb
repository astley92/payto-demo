VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :faraday
  config.filter_sensitive_data('<SOMETHING-SECRET>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end
