# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token
  has_secure_token :upload_key, length: 36

  def authenticate_with_token(token)
    ActiveSupport::SecurityUtils.secure_compare(token, upload_key)
  end
end
