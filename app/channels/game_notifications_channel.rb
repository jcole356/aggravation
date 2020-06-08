# frozen_string_literal: true

# Channel for game notifications
class GameNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_notifications_channel'
  end

  # Starts the game and renders per player
  def start
    GAME.play
    render_all
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def valid_action(action, player)
    GAME.current_player_idx == player && GAME.turn.state == action
  end
end
