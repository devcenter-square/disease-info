require 'webmock/rspec'

def body_mock
  ["disease"]
end

RSpec.configure do |config|
  config.before do
    stub_request(:get, "http://www.who.int/topics/infectious_diseases/factsheets/en/").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'ruby'}).
      to_return(:status => 200, :body => body_mock, :headers => {})
  end
end