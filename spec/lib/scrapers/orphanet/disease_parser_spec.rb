require 'rails_helper'

describe Scrapers::Orphanet::DiseaseParser do
  let(:disorder_xml) do
    <<~XML
      <Disorder id="17601">
        <OrphaCode>166024</OrphaCode>
        <ExpertLink lang="en">http://www.orpha.net/consor/cgi-bin/OC_Exp.php?lng=en&amp;Expert=166024</ExpertLink>
        <Name lang="en">Multiple epiphyseal dysplasia syndrome</Name>
        <DisorderType id="21394">
          <Name lang="en">Disease</Name>
        </DisorderType>
        <PrevalenceList count="2">
          <Prevalence id="8322">
            <Source>11389160[PMID]</Source>
            <PrevalenceType id="23697">
              <Name lang="en">Cases/families</Name>
            </PrevalenceType>
            <PrevalenceQualification id="23718">
              <Name lang="en">Case(s)</Name>
            </PrevalenceQualification>
            <PrevalenceClass/>
            <ValMoy>4.0</ValMoy>
            <PrevalenceGeographic id="23844">
              <Name lang="en">Worldwide</Name>
            </PrevalenceGeographic>
            <PrevalenceValidationStatus id="25958">
              <Name lang="en">Validated</Name>
            </PrevalenceValidationStatus>
          </Prevalence>
          <Prevalence id="8323">
            <Source>ORPHANET</Source>
            <PrevalenceType id="23669">
              <Name lang="en">Point prevalence</Name>
            </PrevalenceType>
            <PrevalenceQualification id="23704">
              <Name lang="en">Class only</Name>
            </PrevalenceQualification>
            <PrevalenceClass id="23760">
              <Name lang="en">&lt;1 / 1 000 000</Name>
            </PrevalenceClass>
            <ValMoy>0.0</ValMoy>
            <PrevalenceGeographic id="23844">
              <Name lang="en">Worldwide</Name>
            </PrevalenceGeographic>
            <PrevalenceValidationStatus id="25958">
              <Name lang="en">Validated</Name>
            </PrevalenceValidationStatus>
          </Prevalence>
        </PrevalenceList>
      </Disorder>
    XML
  end

  let(:node) { Nokogiri::XML(disorder_xml).at_xpath('//Disorder') }
  let(:parser) { described_class.new(node) }

  describe '#data' do
    it 'returns disease data with ORPHANET source suffix' do
      data = parser.data
      expect(data[:name]).to eq('Multiple epiphyseal dysplasia syndrome - ORPHANET')
    end

    it 'sets data_source to ORPHANET' do
      expect(parser.data[:data_source]).to eq('ORPHANET')
    end

    it 'sets the expert link as more' do
      expect(parser.data[:more]).to include('orpha.net')
    end

    it 'initializes array fields as empty arrays' do
      data = parser.data
      %i[facts symptoms transmission diagnosis treatment prevention].each do |field|
        expect(data[field]).to eq([])
      end
    end

    it 'parses prevalence from point prevalence class' do
      expect(parser.data[:prevalence]).to eq(0.05)
    end
  end

  describe 'prevalence parsing' do
    context 'with ValMoy greater than zero' do
      let(:disorder_xml) do
        <<~XML
          <Disorder>
            <Name lang="en">Test Disease</Name>
            <ExpertLink lang="en">http://example.com</ExpertLink>
            <PrevalenceList count="1">
              <Prevalence>
                <PrevalenceType><Name lang="en">Point prevalence</Name></PrevalenceType>
                <PrevalenceClass><Name lang="en">1-9 / 100 000</Name></PrevalenceClass>
                <ValMoy>3.5</ValMoy>
              </Prevalence>
            </PrevalenceList>
          </Disorder>
        XML
      end

      it 'uses ValMoy when it is greater than zero' do
        expect(parser.data[:prevalence]).to eq(3.5)
      end
    end

    context 'with no point prevalence' do
      let(:disorder_xml) do
        <<~XML
          <Disorder>
            <Name lang="en">Test Disease</Name>
            <ExpertLink lang="en">http://example.com</ExpertLink>
            <PrevalenceList count="1">
              <Prevalence>
                <PrevalenceType><Name lang="en">Cases/families</Name></PrevalenceType>
                <PrevalenceClass/>
                <ValMoy>4.0</ValMoy>
              </Prevalence>
            </PrevalenceList>
          </Disorder>
        XML
      end

      it 'returns nil when no point prevalence entry exists' do
        expect(parser.data[:prevalence]).to be_nil
      end
    end

    context 'with no prevalence list' do
      let(:disorder_xml) do
        <<~XML
          <Disorder>
            <Name lang="en">Test Disease</Name>
            <ExpertLink lang="en">http://example.com</ExpertLink>
            <PrevalenceList count="0"/>
          </Disorder>
        XML
      end

      it 'returns nil' do
        expect(parser.data[:prevalence]).to be_nil
      end
    end

    described_class::PREVALENCE_CLASS_TO_PER_100K.each do |prevalence_class, expected_value|
      context "with prevalence class '#{prevalence_class}'" do
        let(:disorder_xml) do
          escaped_class = prevalence_class.gsub('<', '&lt;').gsub('>', '&gt;')
          <<~XML
            <Disorder>
              <Name lang="en">Test Disease</Name>
              <ExpertLink lang="en">http://example.com</ExpertLink>
              <PrevalenceList count="1">
                <Prevalence>
                  <PrevalenceType><Name lang="en">Point prevalence</Name></PrevalenceType>
                  <PrevalenceClass><Name lang="en">#{escaped_class}</Name></PrevalenceClass>
                  <ValMoy>0.0</ValMoy>
                </Prevalence>
              </PrevalenceList>
            </Disorder>
          XML
        end

        it "converts to #{expected_value} per 100k" do
          expect(parser.data[:prevalence]).to eq(expected_value)
        end
      end
    end
  end
end
