require 'rails_helper'

describe Scrapers::Who::Response do
  let(:url) { 'http://www.who.int/entity/mediacentre/factsheets/fs211/en/index.html'}
  let(:request) { Scrapers::Who::Request.new(url) }
  let(:response) { described_class.new(request) }

  describe '#results' do
    it 'calls open method' do
      VCR.use_cassette('who/scrapers/response_results') do
        allow_any_instance_of(described_class).to receive(:status).and_return(200)
        expect(response).to receive(:open).with(url, {"User-Agent"=>"ruby"})
        response.results
      end
    end

    it 'raises an appropriate exception for a 403' do
      VCR.use_cassette('who/scrapers/response_unauthorized') do
        allow_any_instance_of(described_class).to receive(:status).and_return(403)

        expect {
          response.results
        }.to raise_error(Scrapers::Who::Response::NotAuthorized)
      end
    end
  end

  describe '#status' do
    it 'returns 200 when success' do
      VCR.use_cassette('who/scrapers/response_results') do
        expect(response.status).to eq 200
      end
    end

    it 'returns 403 when request is unauthorized' do
      VCR.use_cassette('who/scrapers/response_unauthorized') do
        allow_any_instance_of(described_class).to receive(:status).and_return(403)
        expect(response.status).to eq 403
      end
    end
  end
end
