module Services
  class GenerateCampaignDiff
    def self.call
      new.call
    end

    def initialize
      @enabled_campaigns = Entities::Campaign.enabled
      @remote_campaigns = Services::FetchRemoteAds.call
    end

    def call
      enabled_campaigns.map do |campaign|
        remote = detect_matching_remote(campaign)

        Services::GenerateDiff.call(campaign, remote)
      end.compact
    end

    private
    attr_reader :enabled_campaigns, :remote_campaigns

    def detect_matching_remote(campaign)
      remote_campaigns.detect do |remote|
        remote[:reference] == campaign.external_reference
      end
    end
  end
end
