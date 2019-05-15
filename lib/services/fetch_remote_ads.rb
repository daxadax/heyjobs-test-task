require 'httparty'

module Services
  class FetchRemoteAds
    def self.call
      new.call
    end

    def initialize
      @ads = request_and_parse_ads
    end

    def call
      @ads.map do |ad|
        {
          ad_description: ad['description'],
          status: map_status(ad['status']),
          reference: ad['reference']
        }
      end
    end

    private

    # NOTE: This mapping makes sense to me as the remote would likely only
    # handle active or paused ads. It's something I would check with the team.
    def map_status(status)
      return 'active' if status == 'enabled'
      'paused'
    end

    def request_and_parse_ads
      response = HTTParty.get(api_location)

      # NOTE: This error handling could also be implemented so that it simply
      # returns an empty array, and depending on the uses of this service that
      # might be preferable. This is a point I would normally discuss with the
      # rest of the team if it were not already clear from planning/previous use.
      no_data_found! unless response.ok?
      JSON.parse(response)['ads']
    end

    def no_data_found!
      message = 'Can\'t fetch remote ads:'
      message += " The remote at #{api_location} did not return any data."
      raise RuntimeError.new(message)
    end

    def api_location
      ENV['REMOTE_ADS_API_LOCATION']
    end
  end
end
