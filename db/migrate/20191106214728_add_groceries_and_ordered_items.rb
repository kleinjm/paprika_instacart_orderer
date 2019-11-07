# frozen_string_literal: true

class AddGroceriesAndOrderedItems < ActiveRecord::Migration[5.2]
  def change
    create_table :grocery_items do |t|
      t.references :order, index: true, null: false, foreign_key: {
        to_table: :orders, on_delete: :cascade
      }
      t.string :sanitized_name, null: false
      t.float :container_count
      t.float :container_amount
      t.float :total_amount
      t.string :unit

      t.timestamps
    end

    create_table :ordered_items do |t|
      t.references :grocery_item, index: true, null: false, foreign_key: {
        to_table: :grocery_items, on_delete: :cascade
      }
      t.string :name, null: false
      t.boolean :previously_purchased, null: false, default: false
      t.float :price
      t.float :total_amount
      t.float :unit
      t.float :size

      t.timestamps
    end
  end
end
