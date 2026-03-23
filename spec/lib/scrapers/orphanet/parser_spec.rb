require 'rails_helper'

describe Scrapers::Orphanet::Parser do
  let(:orphanet_xml) do
    <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <JDBOR>
        <DisorderList count="2">
          <Disorder id="1">
            <OrphaCode>100</OrphaCode>
            <ExpertLink lang="en">http://www.orpha.net/consor/cgi-bin/OC_Exp.php?Expert=100</ExpertLink>
            <Name lang="en">Rare Disease Alpha</Name>
            <PrevalenceList count="1">
              <Prevalence>
                <PrevalenceType><Name lang="en">Point prevalence</Name></PrevalenceType>
                <PrevalenceClass><Name lang="en">1-9 / 1 000 000</Name></PrevalenceClass>
                <ValMoy>0.0</ValMoy>
              </Prevalence>
            </PrevalenceList>
          </Disorder>
          <Disorder id="2">
            <OrphaCode>200</OrphaCode>
            <ExpertLink lang="en">http://www.orpha.net/consor/cgi-bin/OC_Exp.php?Expert=200</ExpertLink>
            <Name lang="en">Rare Disease Beta</Name>
            <PrevalenceList count="1">
              <Prevalence>
                <PrevalenceType><Name lang="en">Point prevalence</Name></PrevalenceType>
                <PrevalenceClass><Name lang="en">1-9 / 100 000</Name></PrevalenceClass>
                <ValMoy>0.0</ValMoy>
              </Prevalence>
            </PrevalenceList>
          </Disorder>
        </DisorderList>
      </JDBOR>
    XML
  end

  let(:empty_page_data) { { facts: [], symptoms: [], diagnosis: [], treatment: [] } }

  before do
    mock_response = instance_double(Scrapers::Orphanet::Response, results: orphanet_xml)
    mock_request = instance_double(Scrapers::Orphanet::Request, response: mock_response)
    allow(Scrapers::Orphanet::Request).to receive(:new).and_return(mock_request)

    page_scraper = instance_double(Scrapers::Orphanet::PageScraper, scrape: empty_page_data)
    allow(Scrapers::Orphanet::PageScraper).to receive(:new).and_return(page_scraper)
  end

  describe '.perform' do
    context 'with valid data' do
      it 'delegates to #perform on an instance' do
        instance = double(perform: :performed)
        allow(described_class).to receive(:new).and_return(instance)
        expect(described_class.perform).to eq :performed
      end

      it 'saves diseases to the database' do
        expect { described_class.perform }.to change { Disease.count }.by(2)
      end

      it 'saves the disease with expected attributes' do
        described_class.perform
        disease = Disease.find_by(name: 'Rare Disease Alpha - ORPHANET')

        expect(disease).to be_present
        expect(disease.data_source).to eq('ORPHANET')
        expect(disease.prevalence).to eq(0.5)
      end

      it 'returns a summary with success count' do
        result = described_class.perform
        expect(result[:successes]).to eq(2)
        expect(result[:failures]).to be_empty
      end
    end

    context 'when an error occurs' do
      before do
        allow(Rails.logger).to receive(:error)
        allow(Rails.logger).to receive(:info)
        allow(Rails.logger).to receive(:warn)
        allow_any_instance_of(Scrapers::Orphanet::DiseaseParser)
          .to receive(:data).and_raise(StandardError, "parse failed")
      end

      it 'does not raise any error' do
        expect { described_class.perform }.to_not raise_error
      end

      it 'logs the error for each failed disease' do
        expect(Rails.logger).to receive(:error)
          .with(/\[Orphanet Scraper\] Failed to process/).at_least(:once)

        described_class.perform
      end

      it 'returns a summary with failure details' do
        result = described_class.perform
        expect(result[:successes]).to eq(0)
        expect(result[:failures].size).to eq(2)
        expect(result[:failures].first).to include(:disease, :error)
      end
    end
  end
end
