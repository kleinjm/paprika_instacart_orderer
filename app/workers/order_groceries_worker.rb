# frozen_string_literal: true

class OrderGroceriesWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)

    GroceryOrderer.new(user: user).call
  end
end
