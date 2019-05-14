require 'httparty'

module Services
  class FetchRemoteAds
    API_LOCATION = ENV['REMOTE_ADS_API_LOCATION']

    def self.call
      new.call
    end

    def initialize
      @ads = request_and_parse_ads
    end

    def call
      @ads.map do |ad|
        {
          description: ad['description'],
          status: map_status(ad['status']),
          reference: ad['reference']
        }
      end
    end

    private

    def map_status(status)
      return 'active' if status == 'enabled'
      'paused'
    end

    def request_and_parse_ads
      response = HTTParty.get(API_LOCATION)

      return Array.new unless response.ok?
      JSON.parse(response)['ads']
    end
  end
end
