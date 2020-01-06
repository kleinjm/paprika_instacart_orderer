# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @order_presenters = OrderPresenter.from_orders(
      Order.where(user_id: current_user.id).order(created_at: :desc)
    )
  end

  def show
    @order = OrderPresenter.new(order: Order.find(params[:id]))
  end

  def create
    # TODO: take in an Order id. Have an unprocessed state
    OrderGroceriesWorker.perform_async(current_user.id)

    respond_to do |format|
      format.html do
        redirect_to orders_path, notice: "Order was successfully queued"
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
