# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resource :home, only: [:show]
  resources :files, only: [:index, :show] do
    post :download, on: :member
  end
  resource :profile, except: [:destroy]
  resource :session, only: [:new, :create, :destroy]
  resources :uploads, only: [:show, :create] do
    post :download, on: :member
  end

  root "homes#show"
end
