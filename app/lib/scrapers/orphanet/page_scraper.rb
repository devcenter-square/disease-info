require 'open-uri'

module Scrapers
  module Orphanet
    class PageScraper
      BASE_URL = 'https://www.orpha.net/en/disease/detail'

      # Maps Orphanet page section headings to our data model fields.
      SECTION_MAP = {
        'clinical description' => :symptoms,
        'diagnostic methods' => :diagnosis,
        'management and treatment' => :treatment
      }.freeze

      attr_reader :orpha_code

      def initialize(orpha_code)
        @orpha_code = orpha_code
      end

      def scrape
        result = { facts: disease_definition, symptoms: [], diagnosis: [], treatment: [] }

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
        @page ||= Nokogiri::HTML(URI.open("#{BASE_URL}/#{orpha_code}", 'User-Agent' => 'ruby'))
      end

      def disease_definition
        definition_heading = find_heading('disease definition')
        return [] unless definition_heading

        collect_paragraphs_after(definition_heading)
      end

      def extract_section(heading_text)
        heading = find_heading(heading_text)
        return [] unless heading

        collect_paragraphs_after(heading)
      end

      def find_heading(text)
        page.css('h2, h3, h4, h5, h6, strong, b').find do |el|
          el.text.strip.downcase.include?(text)
        end
      end

      def collect_paragraphs_after(heading)
        paragraphs = []
        sibling = next_content_element(heading)

        while sibling
          break if heading_element?(sibling)

          if sibling.name == 'p' || (sibling.name == 'div' && sibling.css('p').any?)
            texts = sibling.css('p').any? ? sibling.css('p').map { |p| p.text.strip } : [sibling.text.strip]
            paragraphs.concat(texts.reject(&:blank?))
          elsif sibling.name == 'ul' || sibling.name == 'ol'
            sibling.css('li').each { |li| paragraphs << li.text.strip unless li.text.strip.blank? }
          end

          sibling = next_content_element(sibling)
        end

        paragraphs
      end

      def next_content_element(node)
        current = node.next_sibling || node.parent&.next_sibling
        current = current.next_sibling while current && current.text? && current.text.strip.empty?
        current
      end

      def heading_element?(node)
        return true if node.name.match?(/\Ah[2-6]\z/)
        return true if %w[strong b].include?(node.name) && node.children.size <= 1

        false
      end
    end
  end
end
