require 'test_helper'

class ResumesControllerTest < ActionController::TestCase
  setup do
    @resume = resumes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resumes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resume" do
    assert_difference('Resume.count') do
      post :create, resume: { birthday: @resume.birthday, children: @resume.children, driving_permit: @resume.driving_permit, email: @resume.email, f_name: @resume.f_name, family_status: @resume.family_status, home_phone: @resume.home_phone, icq: @resume.icq, l_name: @resume.l_name, m_name: @resume.m_name, mob_phone: @resume.mob_phone, photo: @resume.photo, sex: @resume.sex, skype: @resume.skype, type_connection: @resume.type_connection }
    end

    assert_redirected_to resume_path(assigns(:resume))
  end

  test "should show resume" do
    get :show, id: @resume
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @resume
    assert_response :success
  end

  test "should update resume" do
    put :update, id: @resume, resume: { birthday: @resume.birthday, children: @resume.children, driving_permit: @resume.driving_permit, email: @resume.email, f_name: @resume.f_name, family_status: @resume.family_status, home_phone: @resume.home_phone, icq: @resume.icq, l_name: @resume.l_name, m_name: @resume.m_name, mob_phone: @resume.mob_phone, photo: @resume.photo, sex: @resume.sex, skype: @resume.skype, type_connection: @resume.type_connection }
    assert_redirected_to resume_path(assigns(:resume))
  end

  test "should destroy resume" do
    assert_difference('Resume.count', -1) do
      delete :destroy, id: @resume
    end

    assert_redirected_to resumes_path
  end
end
