# frozen_string_literal: true

require "rails_helper"

RSpec.describe GroceryOrderer do
  describe "#call" do
    it "orders groceries" do
      stub_insta_login
      user = build_stubbed :user

      orderer = described_class.new(user: user)
      orderer.call
    end
  end

  def stub_insta_login
    stub_request(:post, "https://www.instacart.com/accounts/login").
      to_return(status: 200, body: "", headers: {})
  end
end
