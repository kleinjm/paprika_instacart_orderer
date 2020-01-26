# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :grocery_items

  validates :user_id, presence: true

  serialize :error_messages, Array

  def add_error(error_message)
    error_messages << error_message
  end
end
