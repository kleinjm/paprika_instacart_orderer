# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryOrderer do
  describe "#call" do
    it "creates an order object and orders groceries" do
      stub_instacart_api_client
      stub_item_selector
      stub_quantity_computer

      user = create(:user)
      orderer = described_class.new(user: user)
      order = orderer.call

      expect(order).to be_persisted
      expect(order.user).to eq(user)
      expect(order.error_messages).to be_nil
    end

    it "returns standard errors if order fails and isn't persisted" do
      orderer = described_class.new(user: nil)
      result = orderer.call

      expect(result).to be_a(StandardError)
    end

    it "saves errors to error messages when there is a failure" do
      user = create(:user)
      allow(GroceryImporter).to receive(:call).and_raise("Some error")

      orderer = described_class.new(user: user)
      order = orderer.call

      expect(order).to be_persisted
      expect(order.error_messages).to eq("Some error")
    end
  end

  def stub_instacart_api_client
    allow(InstacartApi::Client).
      to receive(:new).and_return(MockInstacartApiClient.new)
  end

  def stub_item_selector
    item_selector = instance_double ItemSelector
    item = double(
      :item,
      id: 1,
      name: "test item",
      buy_again?: true,
      price: 22.33,
      total_amount: 3,
      unit: "cups",
      size: 10
    )
    allow(item_selector).to receive(:call).and_return(item)
    allow(ItemSelector).to receive(:new).and_return(item_selector)
  end

  def stub_quantity_computer
    quantity_computer = instance_double QuantityComputer
    allow(quantity_computer).to receive(:call).and_return(1)
    allow(QuantityComputer).to receive(:new).and_return(quantity_computer)
  end

  class MockInstacartApiClient
    class MockGrocerySearchItem
      def available?
        true
      end
    end

    def search(*)
      [MockGrocerySearchItem.new]
    end

    def add_item_to_cart(item_id:, quantity:); end
  end
end
