require 'rails_helper'

describe DiseasesController, type: :controller do

  let(:diseases) { create_list(:disease, 3) }

  describe "GET#index" do
    context "with data_source param" do

      it "should assign disease with name like the specified param as disease" do
        disease_name = diseases.last.name[0..3]

        get :index, data_source: disease_name
        expect(assigns(:diseases)).to eq [diseases.last]
      end

      it "should have a http success response" do
        get :index, data_source: diseases.last.name
        expect(response.status).to be 200
      end
    end

    describe "with no data_source param" do
      before do
        get :index
      end

      it "should assign all diseases as diseases" do
        expect(assigns(:diseases)).to eq diseases
      end

      it "should have a http success response" do
        expect(response.status).to be 200
      end
    end
  end

  describe "GET#show" do
    it "should assign disease with name like the specified param as disease" do
      disease_name = diseases.last.name[0..3]

      get :show, disease: disease_name
      expect(assigns(:disease)).to eq diseases.last
    end

    it "should have a http success response" do
      get :show, disease: diseases.last.name
      expect(response.status).to be 200
    end
  end

  describe "PUT#set_active_status" do
    it "should update disease to non-active when param is set to false or zero or empty" do
      [false, nil].each do |value|
        # disease is_active is true by default
        disease = create(:disease)
        put :set_active_status, disease: disease.name, is_active: value
        expect(disease.reload.is_active).to eq false
      end
    end

    it "should update disease to active when given a truthy value" do
      [true, 'true'].each do |value|
        disease = create(:disease, is_active: false)
        put :set_active_status, disease: disease.name, is_active: value
        expect(disease.reload.is_active).to eq true
      end
    end
  end

end
