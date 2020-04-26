# frozen_string_literal: true

Rails.application.routes.draw do
  get 'game/index'
  post 'game/new'
  root 'game#index'
end
