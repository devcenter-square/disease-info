require 'test_helper'

class DiseasesControllerTest < ActionController::TestCase
  setup do
    @disease = diseases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:diseases)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create disease" do
    assert_difference('Disease.count') do
      post :create, disease: {  }
    end

    assert_redirected_to disease_path(assigns(:disease))
  end

  test "should show disease" do
    get :show, id: @disease
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @disease
    assert_response :success
  end

  test "should update disease" do
    patch :update, id: @disease, disease: {  }
    assert_redirected_to disease_path(assigns(:disease))
  end

  test "should destroy disease" do
    assert_difference('Disease.count', -1) do
      delete :destroy, id: @disease
    end

    assert_redirected_to diseases_path
  end
end
