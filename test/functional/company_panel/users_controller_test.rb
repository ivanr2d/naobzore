require 'test_helper'

class CompanyPanel::UsersControllerTest < ActionController::TestCase
  test "should get edit" do
    get :edit
    assert_response :success
  end

end
