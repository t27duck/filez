# frozen_string_literal: true

class RemoveExpiredUploadsJob < ApplicationJob
  def perform
    Upload.expired.find_each do |upload|
      upload.destroy
    end
  end
end
