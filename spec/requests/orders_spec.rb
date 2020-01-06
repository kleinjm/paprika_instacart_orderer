# frozen_string_literal: true

require "rails_helper"

RSpec.describe "orders" do
  describe "GET /orders" do
    it "displays articles" do
      user = sign_in_user
      order = create(:order, user: user)
      presenter = OrderPresenter.new(order: order)

      get orders_path
      expect(response).to be_successful

      html = Nokogiri.HTML(response.body)
      link = html.css("a[data-test-created-at]").first
      expect(link.text).to eq(presenter.created_at_pretty)
      expect(link["href"]).to eq(order_path(order))
    end
  end

  describe "GET /orders/:id" do
    it "displays an article" do
      user = sign_in_user
      order = create(:order, user: user)

      get order_path(order)
      expect(response).to be_successful

      presenter = OrderPresenter.new(order: order)
      expect(response.body).
        to include("Created on #{presenter.created_at_pretty}")
    end
  end
end
