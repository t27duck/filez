# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file
  encrypts_attached :file

  has_secure_token

  scope :expired, -> {
    where(expired_at: ...Time.now).where("download_limit IS NOT NULL AND download_limit > download_count")
  }

  def to_param
    token
  end

  def expired?
    expires_at&.past? || (download_limit.present? && download_limit > download_count)
  end

  def public_downloadable?
    !private? && !expired?
  end
end
