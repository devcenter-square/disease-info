require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = File.join(Rails.root,'spec/fixtures/vcr_cassettes')
  config.hook_into :webmock
end
