# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :fetch_upload, only: [:show, :download]

  def index
  end

  def show
  end

  def download
    send_data @upload.file.download, type: @upload.file.content_type, filename: @upload.file.filename.to_s
  end

  private

  def fetch_upload
    @upload = Upload.find_by!(token: params[:id])
  end
end
