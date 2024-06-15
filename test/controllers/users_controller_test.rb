require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get users_url
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { admin: @user.admin, default_download_limit: @user.default_download_limit, default_expiration_duration: @user.default_expiration_duration, default_private: @user.default_private, password_digest: @user.password_digest, token: @user.token, upload_key: @user.upload_key, username: @user.username } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: { user: { admin: @user.admin, default_download_limit: @user.default_download_limit, default_expiration_duration: @user.default_expiration_duration, default_private: @user.default_private, password_digest: @user.password_digest, token: @user.token, upload_key: @user.upload_key, username: @user.username } }
    assert_redirected_to user_url(@user)
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_redirected_to users_url
  end
end
