# frozen_string_literal: true

require "rails_helper"

RSpec.describe Order do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:grocery_items) }
  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to serialize(:error_messages) }
  it { is_expected.to delegate_method(:add_error).to(:error_object) }
  it { is_expected.to delegate_method(:list_errors).to(:error_object) }
end
