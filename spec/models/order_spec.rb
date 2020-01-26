# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:grocery_items) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to serialize(:error_messages) }

  describe "#add_error" do
    it "adds the given errors to error_messages without dedupping" do
      order = build_stubbed(:order)

      order.add_error("new error")
      order.add_error("new error")

      expect(order.error_messages).to eq(["new error", "new error"])
    end
  end
end
