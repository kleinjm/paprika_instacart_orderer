# frozen_string_literal: true

require "instacart_api"

# Takes in a persisted instance of an Order.
# Iterates over all unpurchased Groceries from Paprika.
# For each Grocery, searches Instacart, selects an optimal Item, and adds the
# Item to the cart.
#
# Handles errors by saving them to the Order.error_messages.
# Returns the given Order instance.
class GroceryOrderer
  def initialize(order:)
    @order = order
    @user = order.user
  end

  # returns an order which may have error_messages or throws an error
  def call
    unpurchased_groceries.each(&method(:order_grocery))
  rescue StandardError => e
    order.add_error(e.inspect)
  end

  private

  attr_reader :user, :order

  def unpurchased_groceries
    GroceryImporter.call(user: user).reject(&:purchased)
  end

  def order_grocery(grocery)
    search_results = search_grocery(grocery: grocery)
    sanitize_results(search_results: search_results)
    return if search_results.none?

    item =
      select_optimal_item(search_results: search_results, grocery: grocery)
    return unless item

    quantity = compute_quantity(grocery: grocery, item: item)

    insta_client.add_item_to_cart(item_id: item.id, quantity: quantity)

    create_grocery_item(grocery: grocery, ordered_item: item)
  rescue StandardError => e
    order.add_error(
      "Error ordering grocery", grocery: grocery.name, error: e.inspect
    )
  end

  def search_grocery(grocery:)
    results = insta_client.search(term: grocery.sanitized_name)

    order.add_error("No search results", grocery: grocery.name) if results.none?

    results
  rescue Net::OpenTimeout # TODO: move to instacart-api gem
    order.add_error("Instacart API timeout", grocery: grocery.name)
    []
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

  def sanitize_results(search_results:)
    search_results.select!(&:available?) # remove unavailable
    return unless search_results.none?

    # failures << Failure.new(
    #   name: grocery.sanitized_name,
    #   type: :grocery,
    #   error: "No available search result items found from Instacart"
    # )
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

  def insta_client
    @insta_client ||= InstacartApi::Client.new(
      email: @user.instacart_email,
      password: @user.instacart_password,
      default_store: @user.instacart_default_store
    )
  end
end
