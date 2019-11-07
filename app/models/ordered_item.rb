# frozen_string_literal: true

class OrderedItem < ApplicationRecord
  belongs_to :grocery_item
end
