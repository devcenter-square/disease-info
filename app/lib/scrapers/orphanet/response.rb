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
        raise NotAuthorized if status == 403

        raw_response
      end

      def status
        raw_response.status[0].to_i
      end

      private

      def raw_response
        @raw_response ||= URI.open(request.url, 'User-Agent' => 'ruby')
      end
    end
  end
end
