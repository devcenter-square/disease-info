require 'rails_helper'

RSpec.describe Disease, type: :model do
  it "should have a valid factory" do
    disease = FactoryGirl.build(:disease)
    expect(disease).to be_valid
  end

  describe "Validators" do
    it "should ensure the presence of name" do
      disease = FactoryGirl.build(:disease, name: nil)
      expect(disease).not_to be_valid
      expect(disease.errors[:name]).to be_present
    end
  end

  describe "Behavior" do
  	pending "add some examples to #{__FILE__} for behaviours or delete the 'Behaviour' test there."
  end
end
