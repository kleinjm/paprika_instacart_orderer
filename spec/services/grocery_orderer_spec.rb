# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryOrderer do
  describe "#call" do
    it "orders groceries" do
      stub_instacart_api_client
      stub_item_selector
      stub_quantity_computer

      groceries = [garlic_grocery]
      allow(GroceryImporter).to receive(:call).and_return(groceries)

      order = create(:order)
      described_class.new(order: order).call

      expect(order.grocery_items.count).to eq(1)
      expect(order.error_messages).to be_blank

      grocery_item = order.grocery_items.first
      expect(grocery_item.sanitized_name).to eq("1 t garlic")
      expect(grocery_item.container_count).to eq(1)
      expect(grocery_item.container_amount).to eq(1)
      expect(grocery_item.total_amount).to eq(1)
    end

    it "saves errors to error_messages when there is a failure" do
      allow(GroceryImporter).to receive(:call).and_raise("Some error")

      order = create(:order)
      described_class.new(order: order).call

      expect(order.list_errors).to eq("#<RuntimeError: Some error>")
    end

    it "catches errors ordering groceries and carries on" do
      stub_instacart_api_client
      stub_item_selector

      good_grocery = garlic_grocery
      error_grocery = Grocery.new(name: "unsearchable name", ingredient: "no")
      allow(GroceryImporter).to receive(:call).
        and_return([error_grocery, good_grocery])

      order = create(:order)
      orderer = described_class.new(order: order)

      allow(orderer).to receive(:search_grocery).
        with(grocery: good_grocery).and_call_original
      allow(orderer).to receive(:search_grocery).
        with(grocery: error_grocery).and_raise("SEARCH ERROR")
      orderer.call

      expect(order.list_errors).to eq(
        "Error ordering grocery\n" \
        "Grocery: unsearchable name\n"\
        "Error: #<RuntimeError: SEARCH ERROR>"
      )
      expect(order.grocery_items.first.sanitized_name).to eq("1 t garlic")
    end

    it "records error if no search results are returned for grocery" do
      stub_instacart_api_client(mock_results: false)

      good_grocery = garlic_grocery
      allow(GroceryImporter).to receive(:call).and_return([good_grocery])

      order = create(:order)
      described_class.new(order: order).call

      expect(order.list_errors).to eq(
        "No search results\n" \
        "Grocery: 1 T Garlic"
      )
    end

    it "records timeout errors" do
      good_grocery = garlic_grocery
      allow(GroceryImporter).to receive(:call).and_return([good_grocery])

      insta_client = instance_double InstacartApi::Client
      allow(InstacartApi::Client).to receive(:new).and_return(insta_client)
      allow(insta_client).to receive(:search).and_raise(Net::OpenTimeout)

      order = create(:order)
      described_class.new(order: order).call

      expect(order.list_errors).to eq(
        "Instacart API timeout\n" \
        "Grocery: 1 T Garlic"
      )
    end
  end

  def garlic_grocery
    Grocery.new(name: "1 T Garlic", ingredient: "1 T Garlic")
  end

  def stub_instacart_api_client(mock_results: true)
    allow(InstacartApi::Client).
      to receive(:new).and_return(MockInstacartApiClient.new(mock_results))
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

    def initialize(mock_results)
      @mock_results = mock_results
    end

    def search(*)
      return [MockGrocerySearchItem.new] if mock_results
      []
    end

    def add_item_to_cart(item_id:, quantity:); end

    private

    attr_reader :mock_results
  end
end
