# frozen_string_literal: true

class UploadKeysController < ApplicationController
  def create
    @user_signed_in.regenerate_upload_key

    redirect_to edit_profile_path, notice: translate("flash.upload_key_regenerated")
  end
end
