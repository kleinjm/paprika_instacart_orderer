# frozen_string_literal: true

json.extract! order, :id, :ordered_items, :recipe_ingredients, :created_at, :updated_at
json.url order_url(order, format: :json)
