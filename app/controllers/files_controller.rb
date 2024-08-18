# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :fetch_upload, only: [:show, :update, :destroy, :download]

  def index
    @pagy, @uploads = pagy(Upload.order(created_at: :desc).with_attached_file, items: 30)
  end

  def show
    @share_url = upload_url(@upload.signed_id)
  end

  def new
    @upload = Upload.new
  end

  def create
    @upload = Upload.new(upload_params)
    if @upload.save
      respond_to do |format|
        format.turbo_stream do
          flash[:notice] = translate("flash.file_uploaded")
          render turbo_stream: turbo_stream.action(:redirect, files_path)
        end
        format.html do
          redirect_to files_path, notice: translate("flash.file_uploaded")
        end
      end
    else
      redirect_to files_path, alert: @upload.errors.full_sentences.join
    end
  end

  def update
    if @upload.update(edit_upload_params)
      redirect_to file_path(@upload)
    else
      render :show, status: :unprocessable_entity
    end
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

  def upload_params
    params.require(:upload).permit(:file)
  end

  def edit_upload_params
    params.require(:upload).permit(:private)
  end
end
