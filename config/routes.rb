# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root "orders#index", as: :authenticated_root
    end

    # admin users only
    authenticate :user, ->(u) { u.admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end

  resources :instacart_stores, only: [:edit, :update]
  resources :orders, only: [:create, :index, :show, :destroy]

  root to: "orders#index"
end
