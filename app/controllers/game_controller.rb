# frozen_string_literal: true

# Controller for basic game logic
class GameController < ApplicationController
  # TODO: not sure the best way to handle the view layer
  def new
    ActionCable.server.broadcast 'game_notifications_channel', type: 'new'
    @game = Game.new
    @game.play
    nil
  end

  def index; end
end
