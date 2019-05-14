# Set testing environment
ENV['test'] = 1

# require testing components
require 'minitest/autorun'
require 'minitest/spec'

# require application components
Dir.glob('./lib/**/*.rb') { |f| require f }
require './base_application'
require 'json'

class BaseSpec < Minitest::Spec
  def expand_path(path)
    File.expand_path(path, __FILE__)
  end

  def fixture_data(path)
    full_path = expand_path("../fixtures/#{path}.json")
    JSON.parse(File.read(full_path))
  end
end
