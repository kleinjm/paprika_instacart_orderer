# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "#paprika_credentials" do
    it "raises if paprika_email missing" do
      user = User.new

      expect { user.paprika_credentials }.
        to raise_error("Paprika email not set")
    end

    it "raises if paprika_password missing" do
      user = User.new(paprika_email: "test")

      expect { user.paprika_credentials }.
        to raise_error("Paprika password not set")
    end

    it "returns the paprike email and password" do
      user = User.new(paprika_email: "test_email", paprika_password: "pass")

      expect(user.paprika_credentials).to eq("test_email pass")
    end
  end
end
