ENV['RACK_ENV'] = 'test'
 
require_relative File.join('..', 'app')
 
RSpec.configure do |config|
  include Rack::Test::Methods
 
  # Any values will do here. 
  # They just need to exist since we never actually should call fyber's real api in tests.
  ENV['FYBER_APP_ID'] ||= "101"
  ENV['FYBER_API_KEY'] ||= "ourapikey"

  def app
    App
  end
end

require 'webmock/rspec'