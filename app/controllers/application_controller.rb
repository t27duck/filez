# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!

  helper_method :user_signed_in?

  private

  def require_no_user
    redirect_to root_path if User.any?
  end

  def require_user
    redirect_to new_profile_path unless User.any?
  end

  def sign_in(user)
    cookies.signed[:signin] = { value: user.token, httponly: true, same_site: :lax, expires: 20.minutes }
  end

  def sign_out
    cookies.delete(:signin)
    reset_session
  end

  def user_signed_in?
    @user_signed_in ||= User.exists?(token: cookies.signed[:signin])
  end

  def authenticate_user!
    if user_signed_in?
      sign_in(@user_signed_in)
    else
      redirect_to new_session_path
    end
  end
end
