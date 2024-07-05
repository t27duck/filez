# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :fetch_upload, only: [:show, :download, :destroy]

  def index
    @uploads = Upload.all
  end

  def show
  end

  def destroy
    @upload.destroy!
    redirect_to files_path, status: :see_other
  end

  def download
    send_data @upload.file.download, type: @upload.file.content_type, filename: @upload.file.filename.to_s
  end

  private

  def fetch_upload
    @upload = Upload.find_by!(token: params[:id])
  end
end
