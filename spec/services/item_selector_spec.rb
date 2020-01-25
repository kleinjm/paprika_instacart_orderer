# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemSelector do
  describe "#call" do
    it "selects the cheapest previously purchased item exactly matching name" do
      grocery = Grocery.new(ingredient: "Garlic")

      search_results = [
        double(
          :search_result,
          ingredient: "unmatched not prev purchase",
          name: "unmatched not prev purchase",
          buy_again?: false
        ),
        double(
          :search_result,
          ingredient: "unmatched prev purchase",
          name: "unmatched prev purchase",
          buy_again?: true
        ),
        double(
          :search_result,
          ingredient: "Garlic",
          name: "Garlic",
          buy_again?: true
        )
      ]
      selected = described_class.
                 new(search_results: search_results, grocery: grocery).
                 call

      expect(selected.ingredient).to eq("Garlic")
    end

    it "selects the cheapest previously purchased item" do
      grocery = Grocery.new(ingredient: "Garlic")

      search_results = [
        double(
          :search_result,
          ingredient: "unmatched not prev purchase",
          name: "unmatched not prev purchase",
          buy_again?: false
        ),
        double(
          :search_result,
          ingredient: "unmatched prev purchase",
          name: "unmatched prev purchase",
          buy_again?: true
        )
      ]
      selected = described_class.
                 new(search_results: search_results, grocery: grocery).
                 call

      expect(selected.ingredient).to eq("unmatched prev purchase")
    end

    it "selects the cheapest non-previously purchased item" do
      grocery = Grocery.new(ingredient: "Garlic")

      search_results = [
        double(
          :search_result,
          ingredient: "unmatched not prev purchase",
          name: "unmatched not prev purchase",
          buy_again?: false
        )
      ]
      selected = described_class.
                 new(search_results: search_results, grocery: grocery).
                 call

      expect(selected.ingredient).to eq("unmatched not prev purchase")
    end

    it "returns nothing if no item is selected" do
      grocery = Grocery.new(ingredient: "Garlic")

      selected = described_class.new(search_results: [], grocery: grocery).call

      expect(selected).to be_nil
    end
  end
end
