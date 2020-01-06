# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :user
  end
end
