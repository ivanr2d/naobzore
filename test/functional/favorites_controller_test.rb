require 'test_helper'

class FavoritesControllerTest < ActionController::TestCase
  test "should get plus" do
    get :plus
    assert_response :success
  end

end
