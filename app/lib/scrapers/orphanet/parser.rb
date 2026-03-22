module Scrapers
  module Orphanet
    class Parser
      delegate :response, to: :request
      delegate :results,  to: :response

      def self.perform
        new.perform
      end

      def perform
        successes = 0
        failures = []

        disorder_nodes.each do |node|
          disease_data = Scrapers::Orphanet::DiseaseParser.new(node).data
          Disease.create!(disease_data)
          successes += 1
        rescue StandardError => e
          disease_name = node.at_xpath('Name')&.text rescue 'unknown'
          Rails.logger.error("[Orphanet Scraper] Failed to process #{disease_name}: #{e.message}")
          failures << { disease: disease_name, error: e.message }
          next
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
