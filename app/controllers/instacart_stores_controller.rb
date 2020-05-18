# frozen_string_literal: true

class InstacartStoresController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
    @store_options = client.available_stores
  end

  def update
    @user = current_user

    respond_to do |format|
      format.html do
        if @user.update(instacart_default_store: new_store)
          redirect_to root_path, notice: t(".notice")
        else
          render :edit
        end
      end
    end
  end

  private

  def new_store
    params.require(:user).
      permit(:instacart_default_store)[:instacart_default_store]
  end

  def client
    InstacartApi::Client.new(
      email: @user.instacart_email,
      password: @user.instacart_password
    ).login
  end
end
