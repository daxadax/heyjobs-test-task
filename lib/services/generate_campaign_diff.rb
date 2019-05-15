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

        CampaignDiff.call(campaign, remote)
      end.compact
    end


    private
    attr_reader :enabled_campaigns, :remote_campaigns

    def detect_matching_remote(campaign)
      remote_campaigns.detect do |remote|
        remote[:reference] == campaign.external_reference
      end
    end

    class CampaignDiff
      def self.call(campaign, remote)
        new(campaign, remote).call
      end

      def initialize(campaign, remote)
        @campaign = campaign
        @remote = remote
        @diff = Hash.new
      end

      # NOTE: I chose "diff" rather than "discrepancies" because it's shorter,
      # easier to spell, and is semantically anchored to the 'diff' utility
      def call
        return if same_description? && same_status?
        {
          remote_reference: campaign.external_reference,
          diff: build_diff
        }
      end

      private
      attr_reader :campaign, :diff, :remote

      def build_diff
        unless same_description?
          diff[:description] = {
            local: campaign.ad_description,
            remote: remote[:description]
          }
        end

        unless same_status?
          diff[:status] = {
            local: campaign.status,
            remote: remote[:status]
          }
        end

        diff
      end

      def same_description?
        remote[:description] == campaign.ad_description
      end

      def same_status?
        remote[:status] == campaign.status
      end
    end
  end
end
