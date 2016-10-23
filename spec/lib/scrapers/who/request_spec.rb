require 'rails_helper'

describe Scrapers::Who::Request do
  let(:url) { 'test-url' }
  let(:request) { described_class.new(url) }

  describe '#url' do
    it 'returns the url' do
      expect(request.url).to eq url
    end
  end

  describe '#response' do
    it 'returns the response for this request' do
      expect(Scrapers::Who::Response).to receive(:new).with(request) { :response }
      expect(request.response).to eq :response
    end
  end
end
