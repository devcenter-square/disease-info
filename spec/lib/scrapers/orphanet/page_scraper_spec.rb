require 'rails_helper'

describe Scrapers::Orphanet::PageScraper do
  let(:orpha_code) { '558' }
  let(:scraper) { described_class.new(orpha_code) }

  let(:orphapacket_json) do
    {
      'Orphapacket' => {
        'ORPHAcode' => '558',
        'Label' => 'Marfan syndrome',
        'TextSection' => {
          'TextSectionType' => 'Definition',
          'Contents' => 'A systemic connective tissue disorder.'
        },
        'Phenotypes' => [
          { 'Phenotype' => { 'HPOId' => 'HP:0001519', 'HPOTerm' => 'Disproportionate tall stature', 'HPOFrequency' => 'Very frequent (99-80%)' } },
          { 'Phenotype' => { 'HPOId' => 'HP:0001533', 'HPOTerm' => 'Slender build', 'HPOFrequency' => 'Frequent (79-30%)' } }
        ]
      }
    }.to_json
  end

  before do
    allow(URI).to receive(:open)
      .with(
        "#{described_class::BASE_URL}/ORPHApacket_#{orpha_code}.json",
        'User-Agent' => described_class::USER_AGENT,
        open_timeout: described_class::OPEN_TIMEOUT,
        read_timeout: described_class::READ_TIMEOUT
      )
      .and_return(StringIO.new(orphapacket_json))
  end

  describe '#scrape' do
    it 'extracts the disease definition as facts' do
      expect(scraper.scrape[:facts]).to eq(['A systemic connective tissue disorder.'])
    end

    it 'extracts phenotypes as symptoms with frequency' do
      expect(scraper.scrape[:symptoms]).to eq([
        'Disproportionate tall stature (Very frequent (99-80%))',
        'Slender build (Frequent (79-30%))'
      ])
    end

    it 'returns empty arrays for diagnosis and treatment' do
      result = scraper.scrape
      expect(result[:diagnosis]).to eq([])
      expect(result[:treatment]).to eq([])
    end
  end

  describe '#scrape with missing TextSection' do
    let(:orphapacket_json) do
      { 'Orphapacket' => { 'Phenotypes' => [] } }.to_json
    end

    it 'returns empty facts' do
      expect(scraper.scrape[:facts]).to eq([])
    end
  end

  describe '#scrape with missing Phenotypes' do
    let(:orphapacket_json) do
      { 'Orphapacket' => { 'TextSection' => { 'Contents' => 'Test' } } }.to_json
    end

    it 'returns empty symptoms' do
      expect(scraper.scrape[:symptoms]).to eq([])
    end
  end

  describe '#scrape when fetch fails' do
    before do
      allow(URI).to receive(:open).and_raise(OpenURI::HTTPError.new('404', StringIO.new))
    end

    it 'returns empty arrays for all fields' do
      expect(scraper.scrape).to eq(facts: [], symptoms: [], diagnosis: [], treatment: [])
    end
  end

  describe '#scrape when fetch times out' do
    before do
      allow(URI).to receive(:open).and_raise(Net::OpenTimeout.new('execution expired'))
    end

    it 'returns empty arrays for all fields' do
      expect(scraper.scrape).to eq(facts: [], symptoms: [], diagnosis: [], treatment: [])
    end
  end
end
