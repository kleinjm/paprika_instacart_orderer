# frozen_string_literal: true

require "rails_helper"

RSpec.describe "orders" do
  describe "GET /orders" do
    it "displays articles" do
      user = sign_in_user
      order = create(:order, user: user)

      get orders_path
      expect(response).to be_successful

      html = Nokogiri.HTML(response.body)
      link = html.css("a[data-test-created-at]").first
      expect(link.text).to eq(order.created_at_pretty)
      expect(link["href"]).to eq(order_path(order))
    end
  end

  describe "GET /orders/:id" do
    it "displays an article" do
      user = sign_in_user
      order = create(:order, user: user)

      get order_path(order)
      expect(response).to be_successful

      expect(response.body).
        to include("Created on #{order.created_at_pretty}")
    end
  end
end
