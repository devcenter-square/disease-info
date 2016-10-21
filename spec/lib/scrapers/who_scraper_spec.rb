require 'rails_helper'

describe Scrapers::WhoScraper do
  def get_data
    VCR.use_cassette('who/scrapers') do
      Scrapers::WhoScraper.get_data
    end
  end

  describe '#get_data' do
    it 'should save gotten disease to the database' do
      expect { get_data }.to change { Disease.count }
    end
  end
end
