# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryImporter do
  describe "#call" do
    it "returns a list of groceries" do
      groceries = described_class.call

      expect(groceries.count).to_not be_zero
      expect(groceries).to all(be_a(Grocery))
    end
  end
end
