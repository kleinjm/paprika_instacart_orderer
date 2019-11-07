# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_06_214728) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "grocery_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "sanitized_name", null: false
    t.float "container_count"
    t.float "container_amount"
    t.float "total_amount"
    t.string "unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_grocery_items_on_order_id"
  end

  create_table "ordered_items", force: :cascade do |t|
    t.bigint "grocery_item_id", null: false
    t.string "name", null: false
    t.boolean "previously_purchased", default: false, null: false
    t.float "price"
    t.float "total_amount"
    t.float "unit"
    t.float "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["grocery_item_id"], name: "index_ordered_items_on_grocery_item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "error_messages"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "instacart_email"
    t.string "instacart_password"
    t.string "instacart_default_store"
    t.string "paprika_email"
    t.string "paprika_password"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "grocery_items", "orders", on_delete: :cascade
  add_foreign_key "ordered_items", "grocery_items", on_delete: :cascade
  add_foreign_key "orders", "users", on_delete: :cascade
end
