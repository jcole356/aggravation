# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get 'game/index'
  root 'game#index'
end
