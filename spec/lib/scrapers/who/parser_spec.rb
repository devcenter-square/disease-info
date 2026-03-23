require 'rails_helper'

describe Scrapers::Who::Parser do
  let(:disease_data) do
    {
      :name=> "Lassa fever - WHO",
      :date_updated=> "March 2016",
      :facts=> ["facts test"],
      :more=>"Source is https://www.who.int/news-room/fact-sheets/detail/lassa-fever",
      :symptoms=> ["test"],
      :transmission=> ["test"],
      :diagnosis=> ["test"],
      :treatment=> ["test"],
      :prevention=> ["test"]
     }
  end

  let(:fake_links) do
    html = '<a href="/news-room/fact-sheets/detail/lassa-fever">Lassa fever</a>
            <a href="/news-room/fact-sheets/detail/cholera">Cholera</a>'
    Nokogiri::HTML(html).css('a')
  end

  before do
    allow_any_instance_of(described_class).to receive(:disease_list_pages).and_return(fake_links)
  end

  describe '.perform' do
    context 'with valid data' do
      before do
        allow_any_instance_of(Scrapers::Who::DiseaseParser)
          .to receive(:data).and_return(disease_data)
      end

      it 'delegates to #perform on an instance with the given arguments' do
        instance = double(perform: :performed)
        allow(described_class).to receive(:new).and_return(instance)
        expect(described_class.perform).to eq :performed
      end

      it 'should save gotten disease to the database' do
        expect { described_class.perform }.to change { Disease.count }.by(2)
      end

      it 'saves the disease with the expected attributes' do
        described_class.perform
        disease = Disease.first

        expect(disease.name).to eq(disease_data[:name])
        expect(disease.date_updated).to eq(disease_data[:date_updated])
        expect(disease.facts).to eq(disease_data[:facts])
        expect(disease.more).to eq(disease_data[:more])
        expect(disease.symptoms).to eq(disease_data[:symptoms])
        expect(disease.transmission).to eq(disease_data[:transmission])
        expect(disease.diagnosis).to eq(disease_data[:diagnosis])
        expect(disease.treatment).to eq(disease_data[:treatment])
        expect(disease.prevention).to eq(disease_data[:prevention])
      end
    end

    describe 'when got an error' do
      before do
        allow(Rails.logger).to receive(:error)
        allow(Rails.logger).to receive(:info)
        allow(Rails.logger).to receive(:warn)
        allow_any_instance_of(Scrapers::Who::DiseaseParser)
          .to receive(:data).and_raise(StandardError, "parse failed")
      end

      it 'does not raise any error' do
        expect { described_class.perform }.to_not raise_error
      end

      it 'logs the error for each failed disease' do
        expect(Rails.logger).to receive(:error)
          .with(/\[WHO Scraper\] Failed to scrape/).at_least(:once)

        described_class.perform
      end

      it 'returns a summary with failure details' do
        result = described_class.perform
        expect(result[:successes]).to eq(0)
        expect(result[:failures].size).to eq(2)
        expect(result[:failures].first).to include(:link, :error)
      end
    end
  end
end
