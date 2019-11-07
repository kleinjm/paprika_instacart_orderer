# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :grocery_items

  def created_at_pretty
    created_at.strftime("%l:%M%P on %b %e %Y")
  end
end
