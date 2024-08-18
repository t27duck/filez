# frozen_string_literal: true

class UploadsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create]

  before_action :fetch_upload, only: [:show, :download]

  def show
  end

  def create
    @user = User.take
    if authenticate_with_http_token { |token, _options| token == @user.upload_key }
      @upload = Upload.new(upload_params)
      @upload.file = params[:file]
      if @upload.save
        render json: {
          status: 201,
          share_url: upload_url(@upload.signed_id),
          url: file_url(@upload)
        }, status: :created
      else
        render json: { status: 422, errors: @upload.errors.full_sentences }, status: :unprocessable_entity
      end
    else
      render json: { status: 401, errors: ["Not authorized"] }, status: :unauthorized
    end
  end

  def download
    @upload.increment!(:download_count, touch: true) # rubocop:disable Rails/SkipsModelValidations
    send_data @upload.file.download, type: @upload.file.content_type, filename: @upload.file.filename.to_s
  end

  private

  def fetch_upload
    @upload_sid = params[:id]
    @upload = Upload.find_signed(@upload_sid)

    raise ActiveRecord::RecordNotFound if @upload.blank? || @upload.expired?
  end

  def upload_params
    {
      download_count: params[:limit],
      expires: params[:expires]
    }.compact_blank
  end
end
