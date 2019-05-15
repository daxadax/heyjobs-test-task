# Set testing environment env variables
ENV['test'] = '1'
ENV['CAMPAIGNS_DATA_PATH'] = './data/campaigns_diff.csv'
ENV['REMOTE_ADS_API_LOCATION'] = 'https://tinyurl.com/y2rhe2pz'

# require testing components
require 'minitest/autorun'
require 'minitest/spec'
require 'webmock/minitest'

# require application components
Dir.glob('./lib/**/*.rb') { |f| require f }
require 'json'

class BaseSpec < Minitest::Spec
  def expand_path(path)
    File.expand_path(path, __FILE__)
  end

  def fixture_data(path)
    full_path = expand_path("../fixtures/#{path}.json")
    File.read(full_path)
  end

  def default_campaign_attributes
    {
      ad_description: 'trade time for cash',
      external_reference: '400',
      job_id: 1234,
      status: 'active',
      id: 23
    }
  end
end
