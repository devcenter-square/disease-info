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

        disease_page.css('h3').each_with_index do |tag, index|
          CORE_ATTR.each do |attr|
            begin
              collect_data_for(attr, disease_data, tag, index)
            rescue
              next
            end
          end
        end
        disease_data
      end

      private

      def collect_data_for(core_attribute, disease_data, tag, index)
        if tag.text.downcase.include?(core_attribute)
          xpath_text = "//h3[text()=\'#{tag.text}\']/following::p[not(preceding::h3[text()=\'#{disease_page.css("h3")[index+1].text}\'])]".to_s
          attr_text =  disease_page.xpath(xpath_text).text
          disease_data[core_attribute.to_sym] = attr_text
        end
      end

      def build_disease_data
        {
          name: disease_page.css('.headline').children.text.capitalize + ' - ' + DATA_SOURCE,
          date_updated: disease_page.css('.meta span').text.split.last(2).join(" "),
          facts: facts(disease_page),
          more: "Source is http://www.who.int#{disease_link.attributes["href"].value}"
        }
      end

      def facts(disease_page)
        parsed_lists = disease_page.at('h3:contains("Key facts")').try(:next_element)
        if parsed_lists && (lists = parsed_lists.search("li")).present?
          result = lists.inject([]) { |facts, list| facts << list.text.strip }
        end
        return result
      end

      def disease_page
        @disease_data_page ||= Nokogiri::HTML(results)
      end

      def request
        @request ||= Scrapers::Who::Request.new("http://www.who.int#{disease_link.attributes["href"].value}")
      end
    end
  end
end
