# frozen_string_literal: true

class UploadsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]

  before_action :fetch_upload, only: [:show, :download]

  def create
    @user = User.take
    if authenticate_with_http_token { |token, _options| token == @user.upload_key }
      @upload = Upload.new(upload_params)
      @upload.file = params[:file]
      @upload.direct_upload = true
      if @upload.save
        share_url = upload_url(@upload.signed_id) if @upload.public_downloadable?
        render json: {
          status: 201,
          share_url: share_url,
          url: file_url(@upload)
        }, status: :created
      else
        render json: { status: 422, errors: @upload.errors.full_sentences }, status: :unprocessable_entity
      end
    else
      render json: { status: 401, errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def show
  end

  def download
    @upload.increment!(:download_count, touch: true)
    send_data @upload.file.download, type: @upload.file.content_type, filename: @upload.file.filename.to_s
  end

  private

  def fetch_upload
    @upload_sid = params[:id]
    @upload = Upload.find_signed(@upload_sid)

    raise ActiveRecord::RecordNotFound unless @upload.present? && @upload.public_downloadable?
  end

  def upload_params
    {
      download_count: params[:limit],
      expires: params[:expires],
      private: params[:private]
    }.compact_blank
  end
end
