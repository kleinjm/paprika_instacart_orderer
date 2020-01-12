# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderGroceriesWorker do
  describe "#perform" do
    it "calls the GroceryOrderer with the order of the given id" do
      Sidekiq::Testing.inline! do
        order = create(:order)

        orderer = instance_double GroceryOrderer
        allow(GroceryOrderer).to receive(:new).and_return(orderer)
        allow(orderer).to receive(:call)

        OrderGroceriesWorker.perform_async(order.id)

        expect(GroceryOrderer).to have_received(:new).with(order: order)
        expect(orderer).to have_received(:call)
      end
    end
  end
end
