# frozen_string_literal: true

class OrderPresenter
  attr_reader :order

  delegate(
    :created_at,
    :grocery_items,
    :error_messages,
    to: :order
  )

  def initialize(order:)
    @order = order
  end

  def created_at_pretty
    created_at.strftime("%l:%M%P on %b %e %Y")
  end
end
