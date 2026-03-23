namespace :mine_data do
  desc 'Scrape disease data from WHO'
  task who: :environment do
    DataMiner.get_who_data
  end

  desc 'Fetch disease data from Orphanet'
  task orphanet: :environment do
    DataMiner.get_orphanet_data
  end

  desc 'Fetch disease data from all sources'
  task all: :environment do
    DataMiner.get_all_data
  end
end
