require_relative '../../../spec_helper'

describe 'offers' do
  before(:each) do 
    @currentTime = Time.local(2015, 8, 11, 12, 0, 0)
    Timecop.travel(@currentTime)
    allow(Services::HashkeyCalculator).to receive(:build_hash).and_return('ourhash')
  end

  describe 'GET /api/v1/offer' do
    it 'is successful' do
      response_body = File.read("./spec/fyber_responses/offer_api_response.json")
      stub_request(:get, 
        "http://api.sponsorpay.com/feed/v1/offers.json?" + 
        "appid=157&device_id=d1&format=json&hashkey=ourhash&" +
        "ip=1.1.1.1&locale=de&offer_types=112&page=1&pub0=custom&timestamp=#{@currentTime.to_i}&uid=player1")
        .to_return(
          headers: { "Content-Type": "application/json" }, 
          body: response_body
        )

      get '/api/v1/offers?device_id=d1&ip=1.1.1.1&locale=de&offer_types=112&page=1&pub0=custom&uid=player1'

      expect(last_response.status).to eq 200
      data = JSON.parse(last_response.body)
      expect(data["code"]).to eq " OK"
    end

    it 'catches missing paramaters' do
      get '/api/v1/offers?device_id=d1&ip=1.1.1.1&&offer_types=112&page=1&pub0=custom&uid=player1'
      expect(last_response.status).to eq 400
      data = JSON.parse(last_response.body)
      expect(data["errors"]["locale"]).to eq "Parameter is required"
    end

    it 'relays fyber errors' do 
      stub_request(:get, /api.sponsorpay.com/)
        .to_return(
          status: [400, "Bad Request"],
          body: '{ "code": "ERROR_INVALID_STUFF", "message": "really bad request"}'
        )

      get '/api/v1/offers?device_id=d1&ip=1.1.1.1&locale=de&offer_types=112&page=1&pub0=custom&uid=player1'

      expect(last_response.status).to eq 400
      data = JSON.parse(last_response.body)
      expect(data["code"]).to eq "ERROR_INVALID_STUFF"
    end

    it 'gives internal server error when communication breaks down between servers' do 
      stub_request(:get, /api.sponsorpay.com/).to_timeout

      get '/api/v1/offers?device_id=d1&ip=1.1.1.1&locale=de&offer_types=112&page=1&pub0=custom&uid=player1'

      expect(last_response.status).to eq 500
      data = JSON.parse(last_response.body)
      expect(data["code"]).to eq "NETWORK_ERROR"
    end

  end

end