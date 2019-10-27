# frozen_string_literal: true

require "instacart_api"
require_relative "./grocery_importer"
require_relative "./models/failure"
require_relative "./item_selector"
require_relative "./order_recorder"
require_relative "./quantity_computer"

class GroceryOrderer
  def initialize(user:)
    @user = user
    @failures = []
  end

  def call
    ordered_items = order_groceries

    # TODO: record and print out the grocery to item mapping to help spot
    # check what was ordered. Include quantity
    OrderRecorder.record_items(items: ordered_items)

    report_errors
  end

  private

  attr_reader :failures, :user

  def order_groceries
    ordered_items = []

    unpurchased_groceries.each do |grocery|
    # [unpurchased_groceries.first].each do |grocery|
      ordered_items << order_grocery(grocery: grocery)
    end
    ordered_items.flatten
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

    {
      grocery: grocery.to_h,
      item: item.to_h
    }
  rescue StandardError => e
    failures << Failure.new(
      name: grocery.sanitized_name,
      type: :generic,
      error: "Failure ordering grocery: #{e}"
    )
    nil
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

  def report_errors
    return if failures.none?

    puts "**Failure log**"
    failures.each { |failure| puts failure }
  end

  def insta_client
    @insta_client ||= InstacartApi::Client.new(
      email: @user.instacart_email,
      password: @user.instacart_password,
      default_store: @user.instacart_default_store
    )
  end
end
