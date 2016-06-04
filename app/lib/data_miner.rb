require 'open-uri'

module DataMiner
  extend self

  def get_who_data
    Scrapers::WhoScraper.get_data
  end

end
