# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderedItem do
  it { is_expected.to belong_to(:grocery_item) }
end
