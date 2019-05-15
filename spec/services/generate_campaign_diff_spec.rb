require 'spec_helper'

class GenerateCampaignDiffSpec < BaseSpec
  let(:uri) { ENV['REMOTE_ADS_API_LOCATION'] }
  let(:fixture) { fixture_data('remote_ad_results') }
  let(:result) { Services::GenerateCampaignDiff.call }

  describe 'when no remote data is returned' do
    before do
      stub_request(:get, uri).to_return(status: 404, body: '')
    end

    it 'raises a semantic error message' do
      exception = assert_raises RuntimeError do
        result
      end

      assert_includes exception.message, 'Can\'t fetch remote ads'
    end
  end

  describe 'when remote data is returned' do
    before do
      stub_request(:get, uri).to_return(status: 200, body: fixture)
    end

    describe 'when no differences exist between local and remote' do
      before do
        # NOTE: this will build a collection of campaigns with no differences
        # to remote when Campaign#enabled is called
        ENV['CAMPAIGNS_DATA_PATH'] = './data/campaigns_no_diff.csv'
      end

      it 'returns an empty collection' do
        assert_empty result
      end
    end

    describe 'when differences exist between local and remote' do
      before do
        # NOTE: this will build a collection of campaigns with differences
        # to remote when Campaign#enabled is called
        ENV['CAMPAIGNS_DATA_PATH'] = './data/campaigns_diff.csv'
      end

      it 'compiles differences and returns the results' do
        assert_equal 2, result.size

        # test first diff
        assert_equal 1, result[0][:diff].size
        expected_diff = {
          remote: 'active',
          local: 'paused'
        }
        assert_equal expected_diff, result[0][:diff][:status]

        # test second diff
        assert_equal 2, result[1][:diff].size
        expected_status_diff = {
          remote: 'paused',
          local: 'active'
        }
        expected_description_diff = {
          remote: 'Description for campaign 12',
          local: 'Perscription for campaign 12'
        }
        assert_equal expected_status_diff, result[1][:diff][:status]
        assert_equal expected_description_diff, result[1][:diff][:ad_description]
      end
    end
  end
end
