
module Services 
  require 'rest-client'
  require 'json'

  # Knows how to call Fyber's offer service and return offers based on a set of params
  class OfferService

    # Raised when Fyber gives us some proper error code
    class OfferServiceError < StandardError
      attr_reader :info

      def initialize(message, info)
        super(message)
        @info = info
      end
    end


    def initialize(app_id, api_key)
      @app_id = app_id
      @api_key = api_key
    end

    def get_offers(
      device_id: nil, 
      locale: nil, 
      ip: nil, 
      offer_types: nil,
      uid: nil,
      pub0: nil,
      page: nil)
      
      params = {
        format: "json",
        appid: @app_id,
        device_id: device_id,
        locale: locale,
        ip: ip,
        offer_types: offer_types,
        uid: uid,
        timestamp: Time.now.to_i,
        pub0: pub0,
        page: page,
      }

      request_params = without_nils(params)

      params[:hashkey] = HashkeyCalculator.build_hash(params, @api_key)

      begin
        response = RestClient.get "http://api.sponsorpay.com/feed/v1/offers.json", { params: params }
      rescue => e
        if (e.response)
          # Pass along useful information
          error_info = parse_error_body(e.response)
          raise OfferServiceError.new("Fyber returned error", error_info)
        else
          # Assume a network communication error
          raise OfferServiceError.new(e.message, {"code" => "NETWORK_ERROR", "message" => "Service currently unavailable. Try again later"})
        end
      end

      JSON.parse(response)
    end


    private

    def without_nils(params)
      params.clone.delete_if { |k, v| v.nil? }
    end

    # attempts to parse error_body with default if it fails.
    def parse_error_body(error_body)
      begin 
        JSON.parse(error_body)
      rescue
        { "code" => "UNKNOWN_ERROR", "message" => "We are unaware of what caused this error" }
      end
    end

  end
end