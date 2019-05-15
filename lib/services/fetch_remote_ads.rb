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

      # NOTE: This error handling could also be implemented so that it simply
      # returns an empty array, and depending on the uses of this service that
      # might be preferable. This is a point I would normally discuss with the
      # rest of the team if it were not already clear from planning/previous use.
      no_data_found! unless response.ok?
      JSON.parse(response)['ads']
    end

    def no_data_found!
      message = 'Can\'t fetch remote ads:'
      message += " The remote at #{API_LOCATION} did not return any data."
      raise RuntimeError.new(message)
    end
  end
end
