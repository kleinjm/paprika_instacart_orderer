# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @order_presenters = OrderPresenter.from_orders(
      Order.where(user_id: current_user.id).order(created_at: :desc)
    )
  end

  def show
    order = Order.find_by!(id: params[:id], user_id: current_user.id)
    @order_presenter = OrderPresenter.new(order: order)
  end

  def create
    order = Order.create!(user: current_user)
    OrderGroceriesWorker.perform_async(order.id)

    respond_to do |format|
      format.html { redirect_to order_path(order), notice: t(".notice") }
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
