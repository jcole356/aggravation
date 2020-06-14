# frozen_string_literal: true

# Probably should not be where the game is instantiated?
module ApplicationCable
  class Channel < ActionCable::Channel::Base
    GAME = Game.new

    # TODO: private or protected?
    def render_all
      GAME.players.each do |player|
        ActionCable.server.broadcast "player_#{player.id}",
                                     { type: 'render',
                                       state: GAME.render(player.id) }
      end
    end
  end
end
