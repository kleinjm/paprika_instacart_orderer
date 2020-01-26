# frozen_string_literal: true

require "rails_helper"

RSpec.describe Grocery do
  describe "#sanitized_name" do
    it "returns the downcased ingredient name singular" do
      grocery = Grocery.new(ingredient: "Pears")

      expect(grocery.sanitized_name).to eq("pear")
    end

    it "returns the downcased ingredient name without filtered words" do
      grocery = Grocery.new(ingredient: "fresh sliced Pears small")

      expect(grocery.sanitized_name).to eq("pear")
    end
  end

  describe "#container_count" do
    it "parses the ingredient count" do
      grocery = Grocery.new(name: "2 15oz cans Beans")

      expect(grocery.container_count).to eq(2)
    end

    it "handles ArgumentErrors not handled by Ingreedy" do
      grocery = Grocery.new(name: "Garlic")

      expect(grocery.container_count).to eq(1)
    end
  end

  describe "#container_amount" do
    it "parses the container amount" do
      grocery = Grocery.new(name: "2 15oz cans Beans")

      expect(grocery.container_amount).to eq(15)
    end
  end

  describe "#total_amount" do
    it "returns the container * total amount" do
      grocery = Grocery.new(name: "2 15oz cans Beans")

      expect(grocery.total_amount).to eq(30)
    end
  end

  describe "#unit" do
    it "parses the unit" do
      grocery = Grocery.new(name: "2 15oz cans Beans")

      expect(grocery.unit).to eq(:ounce)
    end
  end
end
