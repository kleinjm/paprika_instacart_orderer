# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderErrors do
  describe "declarations" do
    subject { described_class.new(build_stubbed(:order)) }

    it { is_expected.to delegate_method(:error_messages).to(:order) }
  end

  describe "#add_error & #list_errors" do
    it "adds and concats the error messages" do
      order_errors = described_class.new(build_stubbed(:order))

      order_errors.add_error("new error")
      order_errors.add_error("new error")

      expect(order_errors.list_errors).to eq("new error\n\nnew error")
    end

    it "adds and concats error metadata" do
      order_errors = described_class.new(build_stubbed(:order))

      order_errors.add_error(
        "something happened", grocery_name: "grocery name", error: "error!"
      )
      order_errors.add_error(
        "something happened again", name: "another name", error: "error name"
      )

      expect(order_errors.list_errors).to eq(
        "something happened\nGrocery name: grocery name\nError: error!\n\n" \
        "something happened again\nName: another name\nError: error name"
      )
    end
  end
end
