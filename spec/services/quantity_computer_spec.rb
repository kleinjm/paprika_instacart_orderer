# frozen_string_literal: true

require "rails_helper"

RSpec.describe QuantityComputer do
  describe "#call" do
    [
      {
        grocery: {
          name: "2 14 oz can chickpeas(drained)",
          ingredient: "chickpeas",
          quantity: "2 14 oz can"
        },
        item: { size: "15 oz", unit: "each" },
        result: 2
      },
      {
        grocery: {
          name: "tissues",
          ingredient: "tissues",
          quantity: ""
        },
        item: { size: "160 ct", unit: "each" },
        result: 1
      },
      {
        grocery: {
          name: "4 whole grain tortilla",
          ingredient: "whole grain tortilla",
          quantity: "4"
        },
        item: { size: "12 oz", unit: "each" },
        result: 1
      },
      {
        grocery: {
          name: "1 avocado sliced",
          ingredient: "avocado",
          quantity: "1"
        },
        item: { size: "", unit: "each" },
        result: 1
      },
      {
        grocery: {
          name: "10 oz spinach",
          ingredient: "spinach",
          quantity: "10 oz"
        },
        item: { size: "5 oz", unit: "each" },
        result: 2
      },
      {
        grocery: {
          name: "2 medium sweet potato(chopped into 1/4 inch cubes (to yield 2 cups))",
          ingredient: "medium sweet potato",
          quantity: "2"
        },
        item: { size: "At $1.98/lb", unit: "each" },
        result: 2
      },
      {
        grocery: {
          name: "14 oz can fire roasted diced tomatoes",
          ingredient: "fire roasted diced tomatoes",
          quantity: "14 oz can"
        },
        item: { size: "28 oz", unit: "each" },
        result: 1
      },
      {
        grocery: {
          name: "5 15 oz cans black beans",
          ingredient: "black beans",
          quantity: "5 15 oz cans"
        },
        item: { size: "15.5 oz", unit: "each" },
        result: 5
      }
    ].each do |test_case|
      it "#{test_case.dig(:grocery, :name)} returns result of " \
         "#{test_case[:result]}" do
        grocery = Grocery.new(**test_case[:grocery])
        item = double :item, **test_case[:item]

        quantity = described_class.new(grocery: grocery, item: item).call

        expect(quantity).to eq(test_case[:result])
      end
    end

    it "rescues and returns 1 for any error" do
      grocery = double :grocery
      allow(grocery).to receive(:unit).and_raise("ERROR")

      result = described_class.new(grocery: grocery, item: nil).call

      expect(result).to eq(1)
    end
  end
end
