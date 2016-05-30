namespace :mine_data do
  desc 'Scrape disease data from WHO'
  task who: :environment do
    DataMiner.who
  end
end


#
# namespace :import do
#   desc 'Imports data from GAE (Google App Engine)'
#   task gae: :environment do
#     puts '[rake] starting import from GAE!'
#     ImportDataFromGaeJob.new.perform
#     puts '[rake] done with GAE import!'
#   end
#
#   desc 'Imports data from CoCo (Content Editor)'
#   task coco: :environment do
#     fail NotImplementedError, 'under construction'
#     # puts '[rake] starting import from CoCo...'
#     # ImportDataFromCocoJob.new.perform
#     # puts '[rake] done with CoCo import!'
#   end
#
#   desc 'Imports data from www (jakku)'
#   task jakku: :environment do
#     fail NotImplementedError, 'under construction'
#     # puts '[rake] starting import from GAE!'
#     # ImportDataFromGaeJob.new.perform
#     # puts '[rake] done with GAE import!'
#   end
#
#   desc 'Synchronizes local database with production'
#   task sync: [:gae]
#   # task sync: [:jakku]
# end
