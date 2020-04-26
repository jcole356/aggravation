# frozen_string_literal: true

# Controller for basic game logic
class GameController < ApplicationController
  def new
    ActionCable.server.broadcast 'game_notifications_channel',
                                 message: 'yeah, you know it'
  end

  def index; end
end
