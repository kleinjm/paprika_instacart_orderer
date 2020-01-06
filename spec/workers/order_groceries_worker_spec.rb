# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderGroceriesWorker do
  describe "#perform" do
    it "calls the GroceryOrderer with the order of the given id" do
      Sidekiq::Testing.inline! do
        user = create(:user)

        orderer = instance_double GroceryOrderer
        allow(GroceryOrderer).to receive(:new).and_return(orderer)
        allow(orderer).to receive(:call)

        OrderGroceriesWorker.perform_async(user.id)

        expect(GroceryOrderer).to have_received(:new).with(user: user)
        expect(orderer).to have_received(:call)
      end
    end
  end
end
