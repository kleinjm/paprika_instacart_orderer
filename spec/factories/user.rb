# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email-#{n}@gmail.com" }
  end
end
