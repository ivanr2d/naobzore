require 'test_helper'

class FeedbacksControllerTest < ActionController::TestCase
  setup do
    @feedback = feedbacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feedbacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feedback" do
    assert_difference('Feedback.count') do
      post :create, feedback: { annonce: @feedback.annonce, comment: @feedback.comment, contentment: @feedback.contentment, entity_id: @feedback.entity_id, entity_type: @feedback.entity_type, minus: @feedback.minus, plus: @feedback.plus, title: @feedback.title, user_id: @feedback.user_id }
    end

    assert_redirected_to feedback_path(assigns(:feedback))
  end

  test "should show feedback" do
    get :show, id: @feedback
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @feedback
    assert_response :success
  end

  test "should update feedback" do
    put :update, id: @feedback, feedback: { annonce: @feedback.annonce, comment: @feedback.comment, contentment: @feedback.contentment, entity_id: @feedback.entity_id, entity_type: @feedback.entity_type, minus: @feedback.minus, plus: @feedback.plus, title: @feedback.title, user_id: @feedback.user_id }
    assert_redirected_to feedback_path(assigns(:feedback))
  end

  test "should destroy feedback" do
    assert_difference('Feedback.count', -1) do
      delete :destroy, id: @feedback
    end

    assert_redirected_to feedbacks_path
  end
end
