require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => { :email => @user. email, :active => @user.active, :f_name => @user.f_name, :l_name => @user.l_name, :m_name => @user.m_name, :passw_token => @user.passw_token, :password => @user.password, :registr_token => @user.registr_token, :account_type => @user.account_type }
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, :id => @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @user
    assert_response :success
  end

  test "should update user" do
    put :update, :id => @user, :user => { :email => @user. email, :active => @user.active, :f_name => @user.f_name, :l_name => @user.l_name, :m_name => @user.m_name, :passw_token => @user.passw_token, :password => @user.password, :registr_token => @user.registr_token, :account_type => @user.account_type }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user
    end

    assert_redirected_to users_path
  end
end
