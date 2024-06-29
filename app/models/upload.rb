# frozen_string_literal: true

class Upload < ApplicationRecord
  has_one_attached :file
  encrypts_attached :file

  has_secure_token
end
