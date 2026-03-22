require 'rails_helper'

describe DataMiner do
  describe "#get_who_data" do
    it "should call the #perform method of Scrapers::Who::Parser" do
      allow(Scrapers::Who::Parser).to receive(:perform)
      DataMiner.get_who_data
    end
  end

  describe "#get_orphanet_data" do
    it "should call the #perform method of Scrapers::Orphanet::Parser" do
      expect(Scrapers::Orphanet::Parser).to receive(:perform)
      DataMiner.get_orphanet_data
    end
  end

  describe "#get_all_data" do
    it "should call both WHO and Orphanet parsers" do
      expect(Scrapers::Who::Parser).to receive(:perform).and_return({ successes: 1, failures: [] })
      expect(Scrapers::Orphanet::Parser).to receive(:perform).and_return({ successes: 1, failures: [] })

      result = DataMiner.get_all_data
      expect(result).to have_key(:who)
      expect(result).to have_key(:orphanet)
    end
  end
end
