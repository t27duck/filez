# frozen_string_literal: true

require "puma/plugin"

Puma::Plugin.create do
  attr_reader :log_writer

  def start(launcher)
    @log_writer = launcher.log_writer

    in_background do
      loop do
        sleep 20 * 60
        log "Enqueuing expiration job"
        RemoveExpiredUploadsJob.perform_later
      end
    end
  end

  private

  def log(...)
    log_writer.log(...)
  end
end
