module Scrapers
  module Who
    class DiseaseParser
      attr_reader :disease_link

      delegate :response, to: :request
      delegate :results, to: :response

      CORE_ATTR = %w(symptoms transmission diagnosis treatment prevention)
      DATA_SOURCE = 'WHO'

      def initialize(disease_link)
        @disease_link = disease_link
      end

      def data
        disease_data = build_disease_data

        disease_page.css('h2').each_with_index do |tag, index|
          CORE_ATTR.each do |attr|
            collect_data_for(attr, disease_data, tag, index)
          rescue StandardError => e
            Rails.logger.warn("[WHO DiseaseParser] Failed to parse '#{attr}' for #{disease_data[:name]}: #{e.message}")
            next
          end
        end
        disease_data
      end

      private

      def collect_data_for(core_attribute, disease_data, tag, index)
        if tag.text.downcase.include?(core_attribute)
          next_h2 = disease_page.css('h2')[index + 1]
          if next_h2
            xpath_text = "//h2[contains(text(),'#{tag.text}')]/following::p[not(preceding::h2[contains(text(),'#{next_h2.text}')])]"
          else
            xpath_text = "//h2[contains(text(),'#{tag.text}')]/following::p"
          end
          attr_text = disease_page.xpath(xpath_text).map { |p| p.text.strip }.reject(&:blank?)
          disease_data[core_attribute.to_sym] = attr_text
        end
      end

      def build_disease_data
        title = disease_page.css('h1').text.strip
        date_el = disease_page.css('meta[name="date"]').first
        date_str = date_el ? date_el['content'] : ''

        {
          name: "#{title} - #{DATA_SOURCE}",
          date_updated: date_str,
          facts: facts(disease_page),
          more: "Source is https://www.who.int#{href}"
        }
      end

      def facts(disease_page)
        key_facts_heading = disease_page.css('h2, h3').find { |h| h.text.downcase.include?('key fact') }
        return [] unless key_facts_heading

        next_section = key_facts_heading.parent.next_sibling
        next_section = next_section.next_sibling while next_section && next_section.text.strip.empty?
        return [] unless next_section

        lists = next_section.css('li')
        lists.map(&:text).map(&:strip)
      end

      def disease_page
        @disease_data_page ||= Nokogiri::HTML(results)
      end

      def href
        disease_link.is_a?(String) ? disease_link : disease_link.attributes['href'].value
      end

      def request
        @request ||= Scrapers::Who::Request.new("https://www.who.int#{href}")
      end
    end
  end
end
