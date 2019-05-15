require 'spec_helper'

class CampaignSpec < BaseSpec
  let(:campaign) { Entities::Campaign.new(default_campaign_attributes) }

  it 'builds a campaign' do
    assert_kind_of Entities::Campaign,  campaign
    assert_equal 'trade time for cash', campaign.ad_description
    assert_equal '400',                 campaign.external_reference
    assert_equal 1234,                  campaign.job_id
    assert_equal 'active',              campaign.status
    assert_equal 23,                    campaign.id
  end

  describe 'missing required attribute' do
    # id attribute is missing
    let(:attributes) do
      {
        ad_description: 'test description',
        external_reference: '222',
        job_id: 5678,
        status: 'deleted'
      }
    end

    it 'raises a semantic error message' do
      exception = assert_raises ArgumentError do
        Entities::Campaign.new(attributes)
      end

      assert_equal "Missing required attribute 'id'", exception.message
    end
  end

  describe 'enabled' do
    let(:result) { Entities::Campaign.enabled }

    it 'returns a collection of all enabled campaigns in the system' do
      assert_equal 3, result.size
      assert_kind_of Entities::Campaign, result.first
    end
  end
end
