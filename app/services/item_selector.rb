# frozen_string_literal: true

class ItemSelector
  def initialize(search_results:, grocery:)
    @grocery = grocery
    @search_results = search_results
  end

  # Finds the best item by
  # 1. filtering items previously purchased
  # 2. filtering items matching name
  # 3. CASE 1 selecting cheapest item matching name and previously purchased
  # 4. CASE 2 selecting cheapest previously purchased item
  # 5. CASE 3 selecting cheapest non-previously purchased item
  def call
    previously_purchased = search_results.select(&:buy_again?)

    name_matching = previously_purchased.select do |item|
      item.name.downcase.match?(grocery.sanitized_name)
    end
    return name_matching.min if name_matching.any?

    return previously_purchased.min if previously_purchased.any?

    never_purchased = search_results.reject(&:buy_again?)
    return never_purchased.min if never_purchased.any?

    nil
  end

  private

  attr_reader :grocery, :search_results
end
