module Scrapers
  module Orphanet
    class Parser
      CONCURRENCY = 5
      REQUEST_DELAY = 0.5

      delegate :response, to: :request
      delegate :results,  to: :response

      def self.perform
        new.perform
      end

      def perform
        successes = 0
        failures = []
        mutex = Mutex.new

        disorder_nodes.each_slice(CONCURRENCY) do |batch|
          threads = batch.map do |node|
            Thread.new do
              disease_data = Scrapers::Orphanet::DiseaseParser.new(node).data
              mutex.synchronize do
                Disease.create!(disease_data)
                successes += 1
              end
            rescue StandardError => e
              disease_name = node.at_xpath('Name')&.text rescue 'unknown'
              mutex.synchronize do
                Rails.logger.error("[Orphanet Scraper] Failed to process #{disease_name}: #{e.message}")
                failures << { disease: disease_name, error: e.message }
              end
            end
          end

          threads.each(&:join)
          sleep(REQUEST_DELAY)
        end

        log_summary(successes, failures)
        { successes: successes, failures: failures }
      end

      private

      def log_summary(successes, failures)
        total = successes + failures.size
        Rails.logger.info("[Orphanet Scraper] Completed: #{successes}/#{total} diseases processed successfully")
        return if failures.empty?

        Rails.logger.warn("[Orphanet Scraper] #{failures.size} disease(s) failed:")
        failures.each { |f| Rails.logger.warn("  - #{f[:disease]}: #{f[:error]}") }
      end

      def disorder_nodes
        @disorder_nodes ||= Nokogiri::XML(results).xpath('//Disorder')
      end

      def request
        @request ||= Scrapers::Orphanet::Request.new
      end
    end
  end
end
