require 'rails_helper'

describe Scrapers::Orphanet::Request do
  let(:request) { described_class.new }

  describe '#url' do
    it 'returns the default Orphadata URL' do
      expect(request.url).to eq Scrapers::Orphanet::Request::URL
    end

    it 'accepts a custom URL' do
      custom = 'http://example.com/data.xml'
      request = described_class.new(custom)
      expect(request.url).to eq custom
    end
  end

  describe '#response' do
    it 'returns the response for this request' do
      expect(Scrapers::Orphanet::Response).to receive(:new).with(request) { :response }
      expect(request.response).to eq :response
    end
  end
end
