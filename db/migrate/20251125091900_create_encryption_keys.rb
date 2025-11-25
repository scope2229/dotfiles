# frozen_string_literal: true

class CreateEncryptionKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :encryption_keys do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :encrypted_key, null: false
      t.string :salt, null: false

      t.timestamps
    end
  end
end
