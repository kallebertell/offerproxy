ENV['RACK_ENV'] ||= 'development'

require 'bundler'

Bundler.require :default, ENV['RACK_ENV'].to_sym

# Should set ENV['FYBER_APP_ID'] and ENV['FYBER_API_KEY'] if they aren't set.
require_relative 'fyber_credentials' if File.exists?('fyber_credentials.rb')
require_relative 'services/offer_service'

class App < Sinatra::Base

  set :root, File.dirname(__FILE__)
 
  def initialize(app = nil)
    super(app)
    fyber_app_id = ENV['FYBER_APP_ID']
    fyber_api_key = ENV['FYBER_API_KEY']

    if (!fyber_app_id || !fyber_api_key)
      raise "You need to pass your app id and api key via env vars or create a fyber_credentials.rb"
    end

    @offer_service = Services::OfferService.new(fyber_app_id, fyber_api_key)
  end

  # Serves our static frontend client
  get '/' do
    send_file File.expand_path('index.html', settings.public_folder)
  end
 
end

