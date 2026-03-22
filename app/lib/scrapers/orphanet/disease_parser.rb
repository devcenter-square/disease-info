module Scrapers
  module Orphanet
    class DiseaseParser
      DATA_SOURCE = 'ORPHANET'

      PREVALENCE_CLASS_TO_PER_100K = {
        '>1 / 1000' => 200.0,
        '1-5 / 10 000' => 30.0,
        '6-9 / 10 000' => 7.5,
        '1-9 / 100 000' => 5.0,
        '1-9 / 1 000 000' => 0.5,
        '<1 / 1 000 000' => 0.05
      }.freeze

      attr_reader :disorder_node

      def initialize(disorder_node)
        @disorder_node = disorder_node
      end

      def data
        {
          name: "#{disease_name} - #{DATA_SOURCE}",
          data_source: DATA_SOURCE,
          date_updated: Date.current.strftime('%B %Y'),
          facts: [],
          symptoms: [],
          transmission: [],
          diagnosis: [],
          treatment: [],
          prevention: [],
          prevalence: parse_prevalence,
          more: expert_link
        }
      end

      private

      def disease_name
        disorder_node.at_xpath('Name').text.strip
      end

      def expert_link
        node = disorder_node.at_xpath('ExpertLink')
        node ? "Source is #{node.text.strip}" : ''
      end

      def parse_prevalence
        point_prev = point_prevalence_node
        return nil unless point_prev

        val_moy = point_prev.at_xpath('ValMoy')&.text&.to_f
        return val_moy if val_moy && val_moy > 0

        prev_class = point_prev.at_xpath('PrevalenceClass/Name')&.text&.strip
        PREVALENCE_CLASS_TO_PER_100K[prev_class]
      end

      def point_prevalence_node
        disorder_node.xpath('.//Prevalence').find do |prev|
          prev.at_xpath('PrevalenceType/Name')&.text&.strip == 'Point prevalence'
        end
      end
    end
  end
end
