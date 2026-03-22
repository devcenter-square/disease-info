require 'open-uri'

module Scrapers
  module Orphanet
    class Response
      class NotAuthorized < StandardError; end

      attr_reader :request

      def initialize(request)
        @request = request
      end

      def results
        raw_response
      rescue OpenURI::HTTPError => e
        raise NotAuthorized if e.io.status[0] == '403'

        raise
      end

      private

      def raw_response
        @raw_response ||= URI.open(request.url, 'User-Agent' => 'ruby')
      end
    end
  end
end
