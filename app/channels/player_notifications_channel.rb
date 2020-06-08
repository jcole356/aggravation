# frozen_string_literal: true

# Channel for player notifications
class PlayerNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def join
    GAME.players << Player.new('Josh', GAME, uuid)
    # ActionCable.server.broadcast "player_#{uuid}",
    #                              { type: 'render', state: GAME.render }
    puts 'JOINED'
    puts uuid
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
