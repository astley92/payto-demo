RSpec.configure do |config|
  config.after(:each) do |example|
    Zepto.instance_variable_set(:@adapter, nil)
  end
end
