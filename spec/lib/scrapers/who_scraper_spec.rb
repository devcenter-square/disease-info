require 'rails_helper'

describe Scrapers::WhoScraper do
  def disease_mock

  end

  let (:scrape_klass) { Scrapers::WhoScraper }

  describe "#get_data" do
    it "should save gotten disease to the database" do
      skip "should test scraper?"
      expect(scrape_klass).to receive(:collect_data).and_return(disease_mock)
      scrape_klass.get_data
    end
  end
end