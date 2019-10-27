# frozen_string_literal: true

class Order < ApplicationRecord
  serialize :ordered_items, Array
  serialize :recipe_ingredients, Array
end
