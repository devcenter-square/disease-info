require 'rails_helper'

describe Scrapers::Who::Parser do
  let(:disease_data) do
    {
      :name=> "Lassa fever - WHO",
      :date_updated=> "March 2016",
      :facts=> ["facts test"],
      :more=>"Source is http://www.who.int/entity/mediacentre/factsheets/fs179/en/index.html",
      :symptoms=> "test",
      :transmission=> "test",
      :diagnosis=> "test",
      :treatment=> "test",
      :prevention=> "test"
     }
  end

  describe '.perform' do
    context 'with valida data' do
      it 'delegates to #perform on an instance with the given arguments' do
        instance = double(perform: :performed)
        expect(described_class).to receive(:new) { instance }
        expect(described_class.perform).to eq :performed
      end

      it 'should save gotten disease to the database' do
        VCR.use_cassette('who/scrapers/parser') do
          allow_any_instance_of(Scrapers::Who::DiseaseParser)
            .to receive(:data).and_return(disease_data)

          expect { described_class.perform }.to change { Disease.count }
        end
      end

      it 'saves the disease with the expected attributes' do
        VCR.use_cassette('who/scrapers/parser') do
          allow_any_instance_of(Scrapers::Who::DiseaseParser)
            .to receive(:data).and_return(disease_data)

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
    end

    describe 'when got an error' do
      it 'does not raise any error' do
        VCR.use_cassette('who/scrapers/parser') do
          allow_any_instance_of(Scrapers::Who::DiseaseParser)
            .to receive(:data).and_raise("this error")

          expect { described_class.perform }.to_not raise_error
        end
      end
    end
  end
end
