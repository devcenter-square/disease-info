require 'rails_helper'

describe DataMiner do
  describe "#get_who_data" do
    it "should call the #get_data method of Scrapers::WhoScraper" do
      expect(Scrapers::WhoScraper).to receive(:get_data)
      DataMiner.get_who_data
    end
  end
end