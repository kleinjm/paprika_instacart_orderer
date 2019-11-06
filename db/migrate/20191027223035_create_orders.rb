# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, index: true, null: false, foreign_key: {
        to_table: :users, on_delete: :cascade
      }
      t.text :error_messages
      t.timestamps
    end
  end
end
