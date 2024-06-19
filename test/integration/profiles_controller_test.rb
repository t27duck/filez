# frozen_string_literal: true

require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should create a user on setup" do
    User.destroy_all

    assert_difference "User.count" do
      post profile_path, params: {
        user: { password: TEST_PASSWORD, password_confirmation: TEST_PASSWORD }
      }
    end

    assert_redirected_to root_path

    follow_redirect!

    assert_redirected_to new_session_path

    follow_redirect!

    assert_response :success
  end

  test "not create additional users after first one is created" do
    assert_no_difference "User.count" do
      post profile_path, params: {
        user: { password: TEST_PASSWORD, password_confirmation: TEST_PASSWORD }
      }
    end

    assert_redirected_to root_path
  end

  test "should fail creating a user on bad input" do
    User.destroy_all

    assert_no_difference "User.count" do
      post profile_path, params: {
        user: { password: TEST_PASSWORD, password_confirmation: "#{TEST_PASSWORD}---" }
      }
    end

    assert_response :unprocessable_entity
  end
end
