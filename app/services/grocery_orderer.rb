# frozen_string_literal: true

require "instacart_api"

class GroceryOrderer
  def initialize(user:)
    @user = user
    @failures = []
  end

  def call
    @order = Order.create(user_id: user.id)
    order_groceries

    record_errors
    order
  rescue StandardError => e
    order.update(error_messages: e)
    order
  end

  private

  attr_reader :failures, :user, :order

  def order_groceries
    unpurchased_groceries.each do |grocery|
      ordered_item = order_grocery(grocery: grocery)
      create_grocery_item(grocery: grocery, ordered_item: ordered_item)
    end
  end

  def order_grocery(grocery:)
    search_results = search_grocery(grocery: grocery)
    sanitize_results(search_results: search_results)
    return if search_results.none?

    item =
      select_optimal_item(search_results: search_results, grocery: grocery)
    return unless item

    quantity = compute_quantity(grocery: grocery, item: item)

    insta_client.add_item_to_cart(item_id: item.id, quantity: quantity)

    item
  rescue StandardError => e
    failures << Failure.new(
      name: grocery.sanitized_name,
      type: :generic,
      error: "Failure ordering grocery: #{e}"
    )
    nil
  end

  def create_grocery_item(grocery:, ordered_item:)
    order.grocery_items.create!(
      sanitized_name: grocery.sanitized_name,
      container_count: grocery.container_count,
      container_amount: grocery.container_amount,
      total_amount: grocery.total_amount,
      unit: grocery.unit,
      ordered_item_attributes: {
        name: ordered_item.name,
        previously_purchased: ordered_item.buy_again?,
        price: ordered_item.price,
        total_amount: ordered_item.total_amount,
        unit: ordered_item.unit,
        size: ordered_item.size
      }
    )
  end

  def search_grocery(grocery:)
    results = insta_client.search(term: grocery.sanitized_name)
    if results.none?
      failures << Failure.new(
        name: grocery.sanitized_name,
        type: :grocery,
        error: "No search results for grocery"
      )
    end

    results
  rescue Net::OpenTimeout
    failures << Failure.new(
      name: grocery.sanitized_name,
      type: :grocery,
      error: "Instacart api search failure"
    )
  end

  def sanitize_results(search_results:)
    search_results.select!(&:available?) # remove unavailable
    return unless search_results.none?

    failures << Failure.new(
      name: grocery.sanitized_name,
      type: :grocery,
      error: "No available search result items found from Instacart"
    )
  end

  def compute_quantity(grocery:, item:)
    QuantityComputer.new(grocery: grocery, item: item).call
  end

  def select_optimal_item(search_results:, grocery:)
    ItemSelector.new(
      search_results: search_results,
      grocery: grocery
    ).call
  end

  def unpurchased_groceries
    return @unpurchased_groceries if defined?(@unpurchased_groceries)

    @unpurchased_groceries = GroceryImporter.call.reject(&:purchased)
  end

  def record_errors
    return if failures.none?

    order.update(error_messages: failures)
  end

  def insta_client
    @insta_client ||= InstacartApi::Client.new(
      email: @user.instacart_email,
      password: @user.instacart_password,
      default_store: @user.instacart_default_store
    )
  end
end
