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
    # Run with DEBUG=true for some more stats
    @order = GroceryOrderer.new(user: current_user)

    respond_to do |format|
      if @order.save
        format.html do
          redirect_to @order, notice: "Order was successfully created."
        end
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json do
          render json: @order.errors, status: :unprocessable_entity
        end
      end
    end
  end
end
