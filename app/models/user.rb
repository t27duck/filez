# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_secure_token
  has_secure_token :upload_key, length: 36
end
