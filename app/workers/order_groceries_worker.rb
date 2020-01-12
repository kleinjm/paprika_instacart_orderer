# frozen_string_literal: true

class OrderGroceriesWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)

    GroceryOrderer.new(order: order).call
  end
end
