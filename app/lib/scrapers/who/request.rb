module Scrapers
  module Who
    class Request
      attr_reader :url

      def initialize(url)
        @url = url
      end

      def response
        @response ||= Scrapers::Who::Response.new(self)
      end
    end
  end
end
