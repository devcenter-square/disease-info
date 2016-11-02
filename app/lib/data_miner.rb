require 'open-uri'

module DataMiner
  extend self

  def get_who_data
    Scrapers::Who::Parser.perform
  end

end
