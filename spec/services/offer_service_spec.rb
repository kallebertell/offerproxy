require_relative '../../services/offer_service.rb'

module Services
  
  describe 'OfferService' do

    before(:each) do
      @offer_service = OfferService.new(157, "ourkey")
    end

    def get_offers_with_default_params
      @offer_service.get_offers(
        device_id: "2b6f0cc904d137be2e1730235f5664094b83",
        locale: "de",
        ip: "109.235.143.113",
        offer_types: "112",
        uid: "player1",
        pub0: "custom",
        page: 1,
      )
    end

    it 'fetches offers with expected params' do 
      currentTime = Time.local(2015, 8, 11, 12, 0, 0)
      Timecop.travel(currentTime)

      allow(HashkeyCalculator).to receive(:build_hash).and_return('ourhash')

      response_body = File.read("./spec/fyber_responses/offer_api_response.json")
      stub_request(:get, 
        "http://api.sponsorpay.com/feed/v1/offers.json?" + 
        "appid=157&device_id=2b6f0cc904d137be2e1730235f5664094b83&format=json&hashkey=ourhash&" +
        "ip=109.235.143.113&locale=de&offer_types=112&page=1&pub0=custom&timestamp=#{currentTime.to_i}&uid=player1")
        .to_return(
          headers: { "Content-Type": "application/json" }, 
          body: response_body
        )

      response = get_offers_with_default_params

      expect(response['code']).to eq " OK"
      expect(response['offers'].count).to eq 1
    end
  

    it 'raises errors when fyber cant be reached' do 
      stub_request(:get, /api.sponsorpay.com/).to_timeout
  
      begin
        get_offers_with_default_params
      rescue => e
        errorCode = e.info["code"]
      end

      expect(errorCode).to eq "NETWORK_ERROR"
    end
  

    it 'raises errors with information when fyber gave some proper error message' do
      stub_request(:get, /api.sponsorpay.com/)
        .to_return(
          status: [400, "Bad Request"],
          body: '{ "code": "ERROR_INVALID_STUFF", "message": "really bad request"}'
        )

      begin
        get_offers_with_default_params
      rescue => e
        errorCode = e.info["code"]
        errorMsg = e.info["message"]
      end

      expect(errorCode).to eq "ERROR_INVALID_STUFF"
      expect(errorMsg).to eq "really bad request"
    end

  end

end