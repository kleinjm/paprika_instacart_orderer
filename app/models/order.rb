# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :grocery_items

  validates :user_id, presence: true

  serialize :error_messages, Array

  delegate :add_error, :list_errors, to: :error_object

  private

  def error_object
    @error_object ||= OrderErrors.new(self)
  end
end
