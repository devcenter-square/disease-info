require 'open-uri'

module DataMiner
  extend self

  def get_who_data
    Scrapers::Who::DiseaseParser.get_data
  end

end
