# frozen_string_literal: true

class SharesController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :fetch_upload

  def new
  end

  def create
    @share_url = upload_url(@upload.signed_id(expires_in: expires))
    render :new
  end

  private

  def fetch_upload
    @upload = Upload.where(private: false).find_by!(token: params[:id])
  end

  def expires
    case params[:expires]
    when "10min"
      10.minutes
    when "1h"
      1.hour
    when "1d"
      1.day
    else
      nil
    end
  end
end
