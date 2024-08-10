# frozen_string_literal: true

class Upload < ApplicationRecord
  attr_reader :expires

  has_one_attached :file
  has_secure_token

  validates :file, attached: true
  validate :validate_and_store_expiration_string

  scope :expired, -> {
    where(expires_at: ...Time.now).or(Upload.where("(download_limit IS NOT NULL AND download_limit > download_count)"))
  }

  def to_param
    token
  end

  def expired?
    expires_at&.past? || (download_limit.present? && download_limit > download_count)
  end

  def expires=(value)
    self.expires_at = nil
    @expires = value
  end

  private

  # custom validation
  def validate_and_store_expiration_string
    return if expires.blank?

    self.expires_at = ActiveSupport::Duration.parse(expires.upcase.strip).from_now
  rescue ActiveSupport::Duration::ISO8601Parser::ParsingError
    self.expires_at = nil
    errors.add(:base, "Expires is not a valid ISO 8601 string")
  end
end
