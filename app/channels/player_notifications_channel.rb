# frozen_string_literal: true

# Channel for player notifications
class PlayerNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def start
    GAME.play
    ActionCable.server.broadcast "player_#{uuid}",
                                 { type: 'render', state: GAME.render }
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
