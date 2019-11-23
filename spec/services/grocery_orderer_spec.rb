# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryOrderer do
  describe "#call" do
    it "creates an order object and orders groceries" do
      stub_instacart_api
      stub_item_selector
      stub_quantity_computer

      user = build_stubbed :user
      orderer = described_class.new(user: user)
      order = orderer.call

      expect(order)
    end
  end

  def stub_instacart_api
    allow(InstacartApi::Client).
      to receive(:new).and_return(MockInstacartApiClient.new)
  end

  def stub_item_selector
    item_selector = instance_double ItemSelector
    item = double :item, id: 1
    allow(item_selector).to receive(:call).and_return(item)
    allow(ItemSelector).to receive(:new).and_return(item_selector)
  end

  def stub_quantity_computer
    quantity_computer = instance_double QuantityComputer
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
