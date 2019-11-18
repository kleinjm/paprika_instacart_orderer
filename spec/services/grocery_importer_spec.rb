# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryImporter do
  describe "#call" do
    it "returns a list of groceries" do
      user = instance_double(User, paprika_credentials: "username password")
      groceries = described_class.call(user: user)

      expect(groceries.count).to_not be_zero
      expect(groceries).to all(be_a(Grocery))
    end
  end
end
