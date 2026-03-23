require 'open-uri'

module Scrapers
  module Orphanet
    class PageScraper
      BASE_URL = 'https://www.orpha.net/en/disease/detail'
      USER_AGENT = 'DiseaseInfoBot/1.0 (disease-info scraper; +https://github.com/devcenter-square/disease-info)'
      OPEN_TIMEOUT = 10
      READ_TIMEOUT = 15

      # Maps Orphanet page section headings to our data model fields.
      # Matched using exact (case-insensitive) comparison against heading text.
      SECTION_MAP = {
        'clinical description' => :symptoms,
        'diagnostic methods' => :diagnosis,
        'management and treatment' => :treatment
      }.freeze

      HEADING_TAGS = %w[h2 h3 h4 h5 h6].freeze

      attr_reader :orpha_code

      def initialize(orpha_code)
        @orpha_code = orpha_code
      end

      def scrape
        result = { facts: extract_section('disease definition'), symptoms: [], diagnosis: [], treatment: [] }

        SECTION_MAP.each do |heading_text, field|
          result[field] = extract_section(heading_text)
        end

        result
      rescue StandardError => e
        Rails.logger.warn("[Orphanet PageScraper] Failed to scrape detail page for #{orpha_code}: #{e.message}")
        { facts: [], symptoms: [], diagnosis: [], treatment: [] }
      end

      private

      def page
        @page ||= Nokogiri::HTML(
          URI.open(
            "#{BASE_URL}/#{orpha_code}",
            'User-Agent' => USER_AGENT,
            open_timeout: OPEN_TIMEOUT,
            read_timeout: READ_TIMEOUT
          )
        )
      end

      def headings
        @headings ||= page.css(HEADING_TAGS.join(', '))
      end

      def extract_section(heading_text)
        index = headings.index { |h| h.text.strip.downcase == heading_text }
        return [] unless index

        heading = headings[index]
        next_heading = headings[index + 1]

        collect_content_between(heading, next_heading)
      end

      def collect_content_between(heading, next_heading)
        if next_heading
          xpath = following_siblings_xpath(heading, next_heading)
        else
          xpath = "//#{heading.name}[normalize-space()='#{heading.text.strip}']/following-sibling::*"
        end

        nodes = page.xpath(xpath)
        extract_text_from_nodes(nodes)
      end

      def following_siblings_xpath(heading, next_heading)
        h_tag = heading.name
        h_text = heading.text.strip
        nh_tag = next_heading.name
        nh_text = next_heading.text.strip

        "//#{h_tag}[normalize-space()='#{h_text}']/following-sibling::*" \
          "[not(self::#{nh_tag}[normalize-space()='#{nh_text}']) " \
          "and not(preceding-sibling::#{nh_tag}[normalize-space()='#{nh_text}']" \
          "[preceding-sibling::#{h_tag}[normalize-space()='#{h_text}']])]"
      end

      def extract_text_from_nodes(nodes)
        paragraphs = []

        nodes.each do |node|
          break if HEADING_TAGS.include?(node.name)

          case node.name
          when 'p'
            paragraphs << node.text.strip unless node.text.strip.empty?
          when 'div'
            node.css('p').each { |p| paragraphs << p.text.strip unless p.text.strip.empty? }
          when 'ul', 'ol'
            node.css('li').each { |li| paragraphs << li.text.strip unless li.text.strip.empty? }
          end
        end

        paragraphs
      end
    end
  end
end
