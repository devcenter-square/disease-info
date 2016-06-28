namespace :mine_data do
  desc 'Scrape disease data from WHO'
  task who: :environment do
    DataMiner.get_who_data
  end
end
