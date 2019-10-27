# frozen_string_literal: true

RSpec.describe GroceryOrderer do
  describe "#call" do
    it "orders groceries" do
      stub_login

      orderer = described_class.new(
        insta_email: "fake@email.com",
        insta_password: "afakepassword"
      )
      orderer.call
    end
  end

  def stub_login
    stub_request(:post, "https://www.instacart.com/accounts/login").
      to_return(status: 200, body: "", headers: {})
  end
end
