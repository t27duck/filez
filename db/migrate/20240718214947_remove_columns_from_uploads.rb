# frozen_string_literal: true

class RemoveColumnsFromUploads < ActiveRecord::Migration[7.2]
  def change
    remove_column :uploads, :private, :boolean, null: false, default: false
    remove_column :uploads, :direct_upload, :boolean, null: false, default: false
  end
end
