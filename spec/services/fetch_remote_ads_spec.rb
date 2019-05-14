require 'spec_helper'

class FetchRemoteAdsSpec < BaseSpec
  let(:uri) { ENV['REMOTE_ADS_API_LOCATION'] }
  let(:fixture) { fixture_data('remote_ad_results') }
  let(:result) { Services::FetchRemoteAds.call }

  describe 'when the api/data is not available (404)' do
    before do
      stub_request(:get, uri).to_return(status: 404, body: '')
    end

    it 'returns an empty collection' do
      assert_empty result
    end
  end

  it 'parses and returns the remote ads' do
    stub_request(:get, uri).to_return(status: 200, body: fixture)
    assert_equal 3, result.size
    assert_equal 'Description for campaign 11', result[0][:description]
    assert_equal '1', result[0][:reference]
    assert_equal 'active', result[0][:status]
  end
end