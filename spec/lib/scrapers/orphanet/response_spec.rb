require 'rails_helper'

describe Scrapers::Orphanet::Response do
  let(:url) { 'http://example.com/data.xml' }
  let(:request) { Scrapers::Orphanet::Request.new(url) }
  let(:response) { described_class.new(request) }

  describe '#results' do
    it 'calls URI.open with the request URL' do
      expect(URI).to receive(:open).with(url, { "User-Agent" => "ruby" })
      response.results
    end

    it 'raises NotAuthorized for a 403 status' do
      io = double('io', status: ['403', 'Forbidden'])
      error = OpenURI::HTTPError.new('403 Forbidden', io)
      allow(URI).to receive(:open).and_raise(error)

      expect {
        response.results
      }.to raise_error(Scrapers::Orphanet::Response::NotAuthorized)
    end

    it 're-raises non-403 HTTP errors' do
      io = double('io', status: ['500', 'Internal Server Error'])
      error = OpenURI::HTTPError.new('500 Internal Server Error', io)
      allow(URI).to receive(:open).and_raise(error)

      expect {
        response.results
      }.to raise_error(OpenURI::HTTPError)
    end
  end
end
