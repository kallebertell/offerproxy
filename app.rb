ENV['RACK_ENV'] ||= 'development'

require 'bundler'

Bundler.require :default, ENV['RACK_ENV'].to_sym

# Should set ENV['FYBER_APP_ID'] and ENV['FYBER_API_KEY'] if they aren't set.
require_relative 'fyber_credentials' if File.exists?('fyber_credentials.rb')
require_relative 'services/offer_service'

class App < Sinatra::Base
  helpers Sinatra::Param

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
 
  # Our Api
  get '/api/v1/offers' do
    content_type :json

    param :device_id, String, required: true
    param :locale, String, required: true
    param :uid, String, required: true
    param :ip, String, required: true

    begin
      offers = @offer_service.get_offers(
        device_id: params['device_id'], 
        locale: params['locale'], 
        uid: params['uid'],
        ip: params['ip'], 
        offer_types: params['offer_types'],
        pub0: params['pub0'],
        page: params['page']
      )
    rescue Services::OfferService::OfferServiceError => e
      halt e.info["status_code"], e.info.to_json
    end

    offers.to_json
  end

end

