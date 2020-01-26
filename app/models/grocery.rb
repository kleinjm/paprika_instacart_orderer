# frozen_string_literal: true

# Example
# {
#   "uid"=>"58798267-E1FE-4321-8717-9C3981A96822-18086-00000A0AF29B1510",
#   "order_flag"=>45,
#   "recipe"=>nil,
#   "recipe_uid"=>nil,
#   "purchased"=>true,
#   "list_uid"=>"9E12FCF54A89FC52EA8E1C5DA1BDA62A6617ED8BDC2AEB6F291B93C7A399F6F6",
#   "aisle"=>"Produce",
#   "name"=>"edamame snack",
#   "separate"=>false,
#   "instruction"=>"",
#   "quantity"=>"",
#   "aisle_uid"=>"F94467760BF4BC6B9521FFA9329D0F1DBCCA0F5AC0808BD8552FB375A565FB9E",
#   "ingredient"=>"edamame snack"
# }
class Grocery
  INGREDIENT_FILTER_WORDS = Regexp.union(%w[fresh sliced large medium small])

  attr_reader :name, :ingredient, :amount, :purchased

  def initialize(params = {})
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

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
  rescue Ingreedy::ParseFailed, ArgumentError
    self.class.new(container_amount: 1, container_unit: nil, unit: nil)
  end
end
