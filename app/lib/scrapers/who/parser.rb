module Scrapers
  module Who
    class Parser
      delegate :response, to: :request
      delegate :results,  to: :response

      def self.perform
        new.perform
      end

      def perform
        successes = 0
        failures = []

        disease_list_pages.each do |link|
          disease_data = Scrapers::Who::DiseaseParser.new(link).data
          Disease.create!(disease_data)
          successes += 1
        rescue StandardError => e
          href = link.is_a?(String) ? link : link.attributes['href']&.value
          Rails.logger.error("[WHO Scraper] Failed to scrape #{href}: #{e.message}")
          failures << { link: href, error: e.message }
          next
        end

        log_summary(successes, failures)
        { successes: successes, failures: failures }
      end

      private

      def log_summary(successes, failures)
        total = successes + failures.size
        Rails.logger.info("[WHO Scraper] Completed: #{successes}/#{total} diseases scraped successfully")
        return if failures.empty?

        Rails.logger.warn("[WHO Scraper] #{failures.size} disease(s) failed:")
        failures.each { |f| Rails.logger.warn("  - #{f[:link]}: #{f[:error]}") }
      end

      def disease_list_pages
        @disease_list_pages ||= Nokogiri::HTML(results).css("a[href*='/news-room/fact-sheets/detail/']")
      end

      def request
        @request ||= Scrapers::Who::Request.new(url)
      end

      def url
        'https://www.who.int/news-room/fact-sheets'
      end
    end
  end
end
