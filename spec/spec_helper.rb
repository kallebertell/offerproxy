ENV['RACK_ENV'] = 'test'
 
require_relative File.join('..', 'app')
 
RSpec.configure do |config|
  include Rack::Test::Methods
 
  def app
    App
  end
end

require 'webmock/rspec'