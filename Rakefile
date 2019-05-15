require 'rake/testtask'
# require contents of lib directory
Dir.glob('./lib/**/*.rb') { |f| require f }

task :default => :test

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = false
  t.warning = false
end

desc 'Run diff on enabled local campaigns vs remote'
task :generate_campaign_diff do
  ENV['CAMPAIGNS_DATA_PATH'] = './data/campaigns_diff.csv'
  ENV['REMOTE_ADS_API_LOCATION'] = 'https://tinyurl.com/y2rhe2pz'
  p Services::GenerateCampaignDiff.call
end
