require 'rails_helper'

describe Scrapers::Who::DiseaseParser do
  let(:fetch_disease_link) do
    VCR.use_cassette('who/scrapers/fetch_disease_link') do
      url = 'http://www.who.int/topics/infectious_diseases/factsheets/en/'
      request = Scrapers::Who::Request.new(url)
      Nokogiri::HTML(request.response.results).css(".auto_archive>li>a").first
    end
  end

  let(:disease_link) { fetch_disease_link }
  let(:parser) { described_class.new(disease_link) }
  let(:parsed_data) {}
  let(:keys) do
    [:name, :date_updated, :facts, :more, :symptoms, :transmission, :diagnosis,
      :treatment, :prevention]
  end

  describe '#data' do
    it 'returns the parsed data' do
      VCR.use_cassette('who/scrapers/parsed_data') do
        expect(parser.data.keys).to eq(keys)
      end
    end

    describe 'when parsed data has invalid data' do
      it 'does not return any error' do
        VCR.use_cassette('who/scrapers/parsed_data') do
          allow_any_instance_of(described_class).to receive(:collect_data_for).and_raise("this error")
          expect { parser.data }.to_not raise_error
        end
      end
    end
  end
end
