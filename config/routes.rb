# frozen_string_literal: true

Rails.application.routes.draw do
  get 'game/index'
  root 'page#index'
end
