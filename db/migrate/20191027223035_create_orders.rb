# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.text :ordered_items
      t.text :recipe_ingredients

      t.timestamps
    end
  end
end
