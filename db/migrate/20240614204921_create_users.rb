# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :password_digest, null: false
      t.string :token, null: false
      t.string :upload_key, null: false

      t.timestamps
    end
  end
end
