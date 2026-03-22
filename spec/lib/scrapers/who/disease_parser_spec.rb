require 'rails_helper'

describe Scrapers::Who::DiseaseParser do
  let(:disease_html) do
    <<~HTML
      <html>
        <head>
          <meta name="date" content="March 2016">
        </head>
        <body>
          <h1>Lassa fever</h1>
          <div>
            <h2>Key facts</h2>
          </div>
          <div>
            <ul>
              <li>Fact one</li>
              <li>Fact two</li>
            </ul>
          </div>
          <h2>Symptoms</h2>
          <p>Fever and headache</p>
          <h2>Transmission</h2>
          <p>Contact with rodents</p>
          <h2>Diagnosis</h2>
          <p>Lab testing</p>
          <h2>Treatment</h2>
          <p>Supportive care</p>
          <h2>Prevention</h2>
          <p>Avoid rodent contact</p>
        </body>
      </html>
    HTML
  end

  let(:disease_link) { '/news-room/fact-sheets/detail/lassa-fever' }
  let(:parser) { described_class.new(disease_link) }
  let(:keys) do
    [:name, :date_updated, :facts, :more, :symptoms, :transmission, :diagnosis,
      :treatment, :prevention]
  end

  before do
    mock_response = instance_double(Scrapers::Who::Response, results: disease_html)
    mock_request = instance_double(Scrapers::Who::Request, response: mock_response)
    allow(Scrapers::Who::Request).to receive(:new).and_return(mock_request)
  end

  describe '#data' do
    it 'returns the parsed data' do
      data = parser.data
      expect(data.keys).to eq(keys)
    end

    it 'parses disease name with source suffix' do
      data = parser.data
      expect(data[:name]).to eq('Lassa fever - WHO')
    end

    it 'parses core attributes from HTML as arrays' do
      data = parser.data
      expect(data[:symptoms]).to eq(['Fever and headache'])
      expect(data[:transmission]).to eq(['Contact with rodents'])
      expect(data[:diagnosis]).to eq(['Lab testing'])
      expect(data[:treatment]).to eq(['Supportive care'])
      expect(data[:prevention]).to eq(['Avoid rodent contact'])
    end

    describe 'when parsed data has invalid data' do
      before do
        allow_any_instance_of(described_class).to receive(:collect_data_for).and_raise(StandardError, "bad html")
      end

      it 'does not return any error' do
        expect { parser.data }.to_not raise_error
      end

      it 'logs a warning for the failed attribute' do
        expect(Rails.logger).to receive(:warn)
          .with(/\[WHO DiseaseParser\] Failed to parse/).at_least(:once)

        parser.data
      end
    end
  end
end
