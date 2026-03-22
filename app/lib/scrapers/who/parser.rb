module Scrapers
  module Who
    class Parser
      delegate :response, to: :request
      delegate :results,  to: :response

      def self.perform
        new.perform
      end

      def perform
        disease_list_pages.map do |link|
          begin
            disease_data = Scrapers::Who::DiseaseParser.new(link).data
            Disease.create(disease_data)
          rescue
            next
          end
        end
      end

      private

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
