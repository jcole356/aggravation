# frozen_string_literal: true

# Controller for basic game logic
class GameController < ApplicationController
  def new
    ActionCable.server.broadcast 'game_notifications_channel',
                                 message: 'you have joined the game'
  end

  def index; end
end
