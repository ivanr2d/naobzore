require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  setup do
    @site = sites(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sites)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site" do
    assert_difference('Site.count') do
      post :create, :site => { :company_id => @site. company_id, :color => @site.color, :contacts => @site.contacts, :menu_items => @site.menu_items, :subdomen => @site.subdomen, :template => @site.template, :title => @site.title }
    end

    assert_redirected_to site_path(assigns(:site))
  end

  test "should show site" do
    get :show, :id => @site
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @site
    assert_response :success
  end

  test "should update site" do
    put :update, :id => @site, :site => { :company_id => @site. company_id, :color => @site.color, :contacts => @site.contacts, :menu_items => @site.menu_items, :subdomen => @site.subdomen, :template => @site.template, :title => @site.title }
    assert_redirected_to site_path(assigns(:site))
  end

  test "should destroy site" do
    assert_difference('Site.count', -1) do
      delete :destroy, :id => @site
    end

    assert_redirected_to sites_path
  end
end
