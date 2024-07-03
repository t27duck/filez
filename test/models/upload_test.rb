# frozen_string_literal: true

require "test_helper"

class UploadTest < ActiveSupport::TestCase
  test "expires set to blank blanks expires_at" do
    upload = Upload.new(expires_at: 2.days.from_now)
    upload.file.attach(
      io: File.open(File.join(ActionDispatch::IntegrationTest.file_fixture_path, "text_file_upload.txt")),
      filename: "text_file_upload.txt",
      content_type: "plain/text"
    )
    upload.expires = ""
    assert_nil upload.expires_at
  end

  test "expires set to valid value sets expires_at and passes validation" do
    travel 1.day do
      upload = Upload.new(expires_at: 2.days.from_now)
      upload.file.attach(
        io: File.open(File.join(ActionDispatch::IntegrationTest.file_fixture_path, "text_file_upload.txt")),
        filename: "text_file_upload.txt",
        content_type: "plain/text"
      )
      upload.expires = "p3d"
      assert upload.valid?
      assert_equal 3.days.from_now, upload.expires_at
    end
  end

  test "expires set to invalid value sets expires_at to nil and fails validation" do
    travel 1.day do
      upload = Upload.new
      upload.file.attach(
        io: File.open(File.join(ActionDispatch::IntegrationTest.file_fixture_path, "text_file_upload.txt")),
        filename: "text_file_upload.txt",
        content_type: "plain/text"
      )
      upload.expires = "p3dBad"
      assert_not upload.valid?
      assert_nil upload.expires_at
      assert_includes upload.errors.full_messages, "Expires is not a valid ISO 8601 string"
    end
  end
end
