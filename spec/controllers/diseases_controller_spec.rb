require 'rails_helper'

describe DiseasesController, type: :controller do

  let(:diseases) { create_list(:disease, 3) }

  describe "GET#index" do
    context "with data_source param" do

      it "should assign disease with name like the specified param as disease" do
        disease_name = diseases.last.name
        disease_name.length.times do |n|
          next if n<3
          get :index, data_source: disease_name[0..n]
          expect(assigns(:diseases)).to eq [diseases.last]
        end
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
      disease_name = diseases.last.name
      disease_name.length.times do |n|
        next if n<3
        get :show, disease: disease_name[0..n]
        expect(assigns(:disease)).to eq diseases.last
      end
    end

    it "should have a http success response" do
      get :show, disease: diseases.last.name
      expect(response.status).to be 200
    end
  end

end
