# frozen_string_literal: true

class DownloadController < ApplicationController
  skip_before_action :authenticate_user!

  before_action :fetch_upload, only: [:show, :download]

  def show
  end

  def download
    @upload.increment!(:download_count, touch: true)
    send_data @upload.file.download, type: @upload.file.content_type, filename: @upload.file.filename.to_s
  end

  private

  def fetch_upload
    @upload = Upload.find_signed(params[:download_id])
    raise ActiveRecord::RecordNotFound unless @upload.present? && @upload.public_downloadable?
  end
end
