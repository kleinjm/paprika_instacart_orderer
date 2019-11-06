# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = GroceryOrderer.new(user: current_user).call

    format.html do
      redirect_to @order, notice: "Order was successfully created."
    end
  end
end
