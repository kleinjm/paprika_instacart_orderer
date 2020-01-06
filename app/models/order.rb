# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :grocery_items
end
