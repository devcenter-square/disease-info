module Scrapers
  module Orphanet
    class Request
      URL = 'https://www.orphadata.com/data/xml/en_product9_prev.xml'

      attr_reader :url

      def initialize(url = URL)
        @url = url
      end

      def response
        @response ||= Scrapers::Orphanet::Response.new(self)
      end
    end
  end
end
