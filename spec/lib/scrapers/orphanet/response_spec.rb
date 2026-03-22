require 'rails_helper'

describe Scrapers::Orphanet::Response do
  let(:url) { 'http://example.com/data.xml' }
  let(:request) { Scrapers::Orphanet::Request.new(url) }
  let(:response) { described_class.new(request) }

  describe '#results' do
    it 'calls URI.open with the request URL' do
      allow_any_instance_of(described_class).to receive(:status).and_return(200)
      expect(URI).to receive(:open).with(url, { "User-Agent" => "ruby" })
      response.results
    end

    it 'raises NotAuthorized for a 403 status' do
      allow_any_instance_of(described_class).to receive(:status).and_return(403)

      expect {
        response.results
      }.to raise_error(Scrapers::Orphanet::Response::NotAuthorized)
    end
  end
end
