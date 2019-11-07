# frozen_string_literal: true

class GroceryItem < ApplicationRecord
  belongs_to :order
  has_one :ordered_item

  accepts_nested_attributes_for :ordered_item
end
