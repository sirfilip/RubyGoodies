RSpec.configure do
  config.use_transactional_fixtures = true
  config.around(:each, use_transactional_fixtures: false) do |example|
    self.use_transactional_fixtures = false
    example.run
    self.use_transactional_fixtures = true
  end
end
