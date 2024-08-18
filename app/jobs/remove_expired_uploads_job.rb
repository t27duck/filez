# frozen_string_literal: true

class RemoveExpiredUploadsJob < ApplicationJob
  def perform
    Upload.expired.find_each(&:destroy)
  end
end
