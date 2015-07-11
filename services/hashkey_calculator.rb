module Services
  require 'digest/sha1'

  # Knows how to create a hash according to the specs found here:
  # http://developer.fyber.com/content/ios/offer-wall/offer-api/
  class HashkeyCalculator
    
    def self.build_hash(params, api_key) 
      sorted_params = sort_alphabetically(params)
      concatenated_params = concatenate_params(sorted_params)
      generate_sha1_hash("#{concatenated_params}&#{api_key}")
    end

    private

    def self.sort_alphabetically(params)
      params.sort.to_h
    end

    def self.concatenate_params(params)
      params.map{|k,v| "#{k}=#{v}"}.join('&')
    end

    def self.generate_sha1_hash(str) 
      Digest::SHA1.hexdigest str
    end

  end

end