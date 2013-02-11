require 'test_helper'

class UserModelsControllerTest < ActionController::TestCase
  setup do
    @user_model = user_models(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_models)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_model" do
    assert_difference('UserModel.count') do
      post :create, :user_model => { :count => @user_model.count, :password => @user_model.password, :user => @user_model.user }
    end

    assert_redirected_to user_model_path(assigns(:user_model))
  end

  test "should show user_model" do
    get :show, :id => @user_model
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user_model
    assert_response :success
  end

  test "should update user_model" do
    put :update, :id => @user_model, :user_model => { :count => @user_model.count, :password => @user_model.password, :user => @user_model.user }
    assert_redirected_to user_model_path(assigns(:user_model))
  end

  test "should destroy user_model" do
    assert_difference('UserModel.count', -1) do
      delete :destroy, :id => @user_model
    end

    assert_redirected_to user_models_path
  end
end
