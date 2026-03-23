require 'rails_helper'

describe Scrapers::Orphanet::PageScraper do
  let(:orpha_code) { '558' }
  let(:scraper) { described_class.new(orpha_code) }

  let(:html) do
    <<~HTML
      <html>
      <body>
        <h3>Disease definition</h3>
        <p>A systemic connective tissue disorder.</p>

        <h3>Clinical description</h3>
        <p>Symptoms can appear at any age.</p>
        <p>Cardiovascular involvement is common.</p>

        <h3>Diagnostic methods</h3>
        <p>Diagnosis is based on clinical signs.</p>

        <h3>Management and treatment</h3>
        <p>Management should be multidisciplinary.</p>
        <ul>
          <li>Regular echocardiograms</li>
          <li>Beta-blocker therapy</li>
        </ul>

        <h3>Prognosis</h3>
        <p>Life expectancy has improved.</p>
      </body>
      </html>
    HTML
  end

  before do
    allow(URI).to receive(:open)
      .with(
        "#{described_class::BASE_URL}/#{orpha_code}",
        'User-Agent' => described_class::USER_AGENT,
        open_timeout: described_class::OPEN_TIMEOUT,
        read_timeout: described_class::READ_TIMEOUT
      )
      .and_return(html)
  end

  describe '#scrape' do
    it 'extracts the disease definition as facts' do
      expect(scraper.scrape[:facts]).to eq(['A systemic connective tissue disorder.'])
    end

    it 'extracts clinical description as symptoms' do
      expect(scraper.scrape[:symptoms]).to eq([
        'Symptoms can appear at any age.',
        'Cardiovascular involvement is common.'
      ])
    end

    it 'extracts diagnostic methods as diagnosis' do
      expect(scraper.scrape[:diagnosis]).to eq(['Diagnosis is based on clinical signs.'])
    end

    it 'extracts management and treatment as treatment' do
      result = scraper.scrape[:treatment]
      expect(result).to eq([
        'Management should be multidisciplinary.',
        'Regular echocardiograms',
        'Beta-blocker therapy'
      ])
    end

    it 'uses exact heading match and does not false-match partial text' do
      html_with_extended = html.sub('Clinical description', 'Extended clinical description')
      allow(URI).to receive(:open).and_return(html_with_extended)

      # "Extended clinical description" should NOT match "clinical description"
      expect(scraper.scrape[:symptoms]).to eq([])
    end
  end

  describe '#scrape when page fetch fails' do
    before do
      allow(URI).to receive(:open).and_raise(OpenURI::HTTPError.new('404', StringIO.new))
    end

    it 'returns empty arrays for all fields' do
      result = scraper.scrape
      expect(result).to eq(facts: [], symptoms: [], diagnosis: [], treatment: [])
    end
  end

  describe '#scrape when page fetch times out' do
    before do
      allow(URI).to receive(:open).and_raise(Net::OpenTimeout.new('execution expired'))
    end

    it 'returns empty arrays for all fields' do
      result = scraper.scrape
      expect(result).to eq(facts: [], symptoms: [], diagnosis: [], treatment: [])
    end
  end
end
