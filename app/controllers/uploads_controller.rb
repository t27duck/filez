# frozen_string_literal: true

class UploadsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  before_action :lookup_user

  def create
    @upload = Upload.new(file: params[:file])
    @upload.save!
    render json: @upload
  end

  private

  def lookup_user
    @user = User.take
    unless authenticate_with_http_token { |token, _options| token == @user.upload_key }
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end
end
