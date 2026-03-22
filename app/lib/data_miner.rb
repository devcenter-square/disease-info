require 'open-uri'

module DataMiner
  extend self

  def get_who_data
    Scrapers::Who::Parser.perform
  end

  def get_orphanet_data
    Scrapers::Orphanet::Parser.perform
  end

  def get_all_data
    { who: get_who_data, orphanet: get_orphanet_data }
  end
end
