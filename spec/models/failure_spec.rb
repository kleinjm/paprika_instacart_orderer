# frozen_string_literal: true

require "models/failure"

RSpec.describe Failure do
  describe "#to_s" do
    it "returns the failure formatted" do
      failure = described_class.new(name: "Name", error: "ERROR", type: "Bad")

      expect(failure.to_s).to eq("Bad: Name - ERROR")
    end
  end
end
