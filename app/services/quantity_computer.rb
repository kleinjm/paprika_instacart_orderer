# frozen_string_literal: true

require "ingreedy"

class QuantityComputer
  def initialize(grocery:, item:)
    @grocery = grocery
    @item = item
  end

  def call
    if grocery.unit == item_unit
      return (grocery.total_amount / item_container_amount).ceil
    end

    # TODO: unit conversion. ie. 1 quart is ordering 12 oz grape tomatoes
    # TODO: Fl-oz should equal oz in the mapping

    1
  rescue StandardError
    1
  end

  private

  attr_reader :grocery, :item

  def item_container_amount
    item_size_parsed.amount
  end

  def item_unit
    item_size_parsed.unit
  end

  def item_size_parsed
    @item_size_parsed ||=
      begin
        Ingreedy.parse(item.size)
      rescue StandardError
        OpenStruct.new(
          amount: 1, container_amount: 1, container_unit: nil, unit: nil
        )
      end
  end
end
