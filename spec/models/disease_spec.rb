require 'rails_helper'

RSpec.describe Disease, type: :model do
  it "should have a valid factory" do
    disease = build(:disease)
    expect(disease).to be_valid
  end

  describe "Validators" do
    it "should ensure the presence of name" do
      disease = build(:disease, name: nil)
      expect(disease).not_to be_valid
      expect(disease.errors[:name]).to be_present
    end

    it "should validate data_source inclusion" do
      disease = build(:disease, data_source: 'INVALID')
      expect(disease).not_to be_valid
      expect(disease.errors[:data_source]).to be_present
    end

    it "should allow nil data_source" do
      disease = build(:disease, data_source: nil)
      expect(disease).to be_valid
    end

    it "should allow WHO and ORPHANET as data_source" do
      %w[WHO ORPHANET].each do |source|
        disease = build(:disease, data_source: source)
        expect(disease).to be_valid
      end
    end
  end

  describe "Scopes" do
    it "should filter by data source" do
      who_disease = create(:disease, data_source: 'WHO')
      orphanet_disease = create(:disease, :orphanet)

      expect(Disease.by_source('WHO')).to eq([who_disease])
      expect(Disease.by_source('ORPHANET')).to eq([orphanet_disease])
    end
  end
end
