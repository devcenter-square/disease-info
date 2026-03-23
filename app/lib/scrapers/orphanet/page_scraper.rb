require 'open-uri'
require 'json'

module Scrapers
  module Orphanet
    class PageScraper
      BASE_URL = 'https://raw.githubusercontent.com/Orphanet/orphapacket/master/json'
      USER_AGENT = 'DiseaseInfoBot/1.0 (disease-info scraper; +https://github.com/devcenter-square/disease-info)'
      OPEN_TIMEOUT = 10
      READ_TIMEOUT = 15

      attr_reader :orpha_code

      def initialize(orpha_code)
        @orpha_code = orpha_code
      end

      def scrape
        {
          facts: definition,
          symptoms: phenotypes,
          diagnosis: [],
          treatment: []
        }
      rescue StandardError => e
        Rails.logger.warn("[Orphanet PageScraper] Failed to fetch ORPHApacket for #{orpha_code}: #{e.message}")
        { facts: [], symptoms: [], diagnosis: [], treatment: [] }
      end

      private

      def packet
        @packet ||= begin
          response = URI.open(
            "#{BASE_URL}/ORPHApacket_#{orpha_code}.json",
            'User-Agent' => USER_AGENT,
            open_timeout: OPEN_TIMEOUT,
            read_timeout: READ_TIMEOUT
          )
          JSON.parse(response.read).fetch('Orphapacket', {})
        end
      end

      def definition
        text_section = packet['TextSection']
        return [] unless text_section.is_a?(Hash)

        contents = text_section['Contents']
        contents.present? ? [contents] : []
      end

      def phenotypes
        entries = packet['Phenotypes']
        return [] unless entries.is_a?(Array)

        entries.filter_map do |entry|
          phenotype = entry['Phenotype']
          next unless phenotype

          term = phenotype['HPOTerm']
          freq = phenotype['HPOFrequency']
          freq ? "#{term} (#{freq})" : term
        end
      end
    end
  end
end
