# frozen_string_literal: true

class CreateUploads < ActiveRecord::Migration[7.2]
  def change
    create_table :uploads do |t|
      t.string :token, null: false
      t.boolean :private, null: false, default: false
      t.boolean :direct_upload, null: false, default: false
      t.integer :download_count, null: false, default: 0
      t.integer :download_limit
      t.datetime :expires_at

      t.timestamps
    end

    add_index :uploads, :token, unique: true
  end
end
