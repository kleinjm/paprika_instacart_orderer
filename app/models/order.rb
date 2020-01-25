# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :grocery_items

  validates :user_id, presence: true

  serialize :error_messages
end
