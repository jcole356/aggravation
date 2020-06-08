# frozen_string_literal: true

# Channel for game notifications
class GameNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_notifications_channel'
  end

  # TODO: this should actually be on the player channel
  def discard(data)
    puts 'DISCARDING'
    return unless valid_action('play', data['player'])

    # TODO: should send this as an int from the client if possible
    GAME.players[data['player']].discard(data['choice'].to_i)
    ActionCable.server.broadcast 'game_notifications_channel',
                                 { type: 'render', state: GAME.render }
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
