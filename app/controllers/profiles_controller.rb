# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :require_no_user, only: [:new, :create]
  before_action :require_user, only: [:edit, :show, :update]
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    @user = User.new
  end

  def edit
    @user = @user_signed_in
  end

  def show
  end

  def create
    @user = User.new(user_password_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: translate("flash.setup_complete") }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    @user = @user_signed_in

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to edit_profile_path, notice: translate("flash.settings_updated") }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
