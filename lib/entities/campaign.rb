require 'csv'

module Entities
  class Campaign
    CAMPAIGNS_DATA_PATH = './data/campaigns.csv'
    attr_reader :ad_description, :external_reference, :job_id, :status, :id

    # NOTE: As the main goal of the task is to implement the business logic
    # surrounding the campaign diff, I am simply mocking such functionality which
    # would most likely be in a running application.
    # NOTE: I chose to use 'enabled' rather than 'all' since it seems like a waste of
    # resources to run the diff on deleted ads. Furthermore I chose to call this
    # 'enabled' rather than 'active' since it should run the diff on paused campaigns
    def self.enabled
      CSV.read(CAMPAIGNS_DATA_PATH, headers: true).map do |row|
        new({
          ad_description: row['ad_description'],
          external_reference: row['external_reference'],
          job_id: row['job_id'],
          status: row['status'],
          id: row['id']
        })
      end
    end

    def initialize(attributes = {})
      @ad_description = set_attribute(attributes, :ad_description)
      @external_reference = set_attribute(attributes, :external_reference)
      @job_id = set_attribute(attributes, :job_id)
      @status = set_attribute(attributes, :status)
      @id = set_attribute(attributes, :id)
    end

    private

    # NOTE: ordinarily would be found in Entity base class or other helper file
    def set_attribute(attributes, name)
      attributes.fetch(name) do
        raise ArgumentError, "Missing required attribute '#{name}'"
      end
    end
  end
end
