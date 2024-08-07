# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

TEST_PASSWORD = "testing123"
ENV["LOCKBOX_MASTER_KEY"] ||= Lockbox.generate_key

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def sign_in
      post session_path, params: { password: TEST_PASSWORD }
    end
  end
end
