require 'rails_helper'

describe DataMiner do
  describe "#get_who_data" do
    it "should call the #perform method of Scrapers::Who::Parser" do
      allow(Scrapers::Who::Parser).to receive(:perform)
      DataMiner.get_who_data
    end
  end
end
