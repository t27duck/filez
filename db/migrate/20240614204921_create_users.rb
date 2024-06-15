class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :password_digest, null: false
      t.string :token, null: false
      t.string :upload_key, null: false
      t.boolean :default_private, null: false, default: true
      t.string :default_expiration_duration
      t.integer :default_download_limit, null: false, default: -1

      t.timestamps
    end
  end
end
