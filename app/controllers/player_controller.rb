# frozen_string_literal: true

class PlayerController < ApplicationController
  def new
    username = params['name']
    puts username
  end
end
