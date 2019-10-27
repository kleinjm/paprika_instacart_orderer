# frozen_string_literal: true

require "active_support/core_ext"
require "ingreedy"
require "ostruct"

class Grocery < OpenStruct
  INGREDIENT_FILTER_WORDS = Regexp.union(%w[fresh sliced large medium small])

  def sanitized_name
    ActiveSupport::Inflector.singularize(
      ingredient.downcase.gsub(INGREDIENT_FILTER_WORDS, "").strip
    )
  end

  def container_count
    parsed_ingredient.amount || 1
  end

  def container_amount
    parsed_ingredient.container_amount || 1
  end

  def total_amount
    container_count * container_amount
  end

  def unit
    parsed_ingredient.container_unit || parsed_ingredient.unit
  end

  private

  def parsed_ingredient
    @parsed_ingredient ||= Ingreedy.parse(name)
  rescue Ingreedy::ParseFailed
    OpenStruct.new(
      amount: 1, container_amount: 1, container_unit: nil, unit: nil
    )
  end
end
