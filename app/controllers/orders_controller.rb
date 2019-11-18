# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    @order = GroceryOrderer.new(user: current_user).call

    respond_to do |format|
      format.html do
        redirect_to @order, notice: "Order was successfully created"
      end
    end
  end

  def destroy
    Order.find(params[:id]).destroy!

    respond_to do |format|
      format.html do
        redirect_to orders_path, notice: "Order was successfully deleted"
      end
    end
  end
end
