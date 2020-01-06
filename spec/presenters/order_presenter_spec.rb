# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderPresenter do
  describe "#created_at_pretty" do
    it "displays the created at date formatted" do
      order = Order.new(created_at: "Sun, 17 Nov 2019 20:57:21 EST -05:00")
      presenter = described_class.new(order: order)

      expect(presenter.created_at_pretty.strip).to eq("8:57pm on Nov 17 2019")
    end
  end
end
