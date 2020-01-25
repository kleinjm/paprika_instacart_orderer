# frozen_string_literal: true

require "rails_helper"

RSpec.describe Grocery do
  describe "#container_count" do
    it "handles ArgumentErrors not handled by Ingreedy" do
      grocery = Grocery.new(ingredient: "Garlic")

      expect(grocery.container_count).to eq(1)
    end
  end
end
