# frozen_string_literal: true

# Channel for game notifications
class GameNotificationsChannel < ApplicationCable::Channel
  # Is before_action a thing here?

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

  # TODO: this should actually be on the player channel
  def draw(data) # rubocop:disable Metrics/AbcSize
    puts 'DRAWING'
    return unless valid_action(data['action'], data['player'])

    case data['choice']
    when 'deck'
      GAME.players[data['player']].draw_from_deck
    when 'pile'
      GAME.players[data['player']].draw_from_pile
    end
    ActionCable.server.broadcast 'game_notifications_channel',
                                 { type: 'render', state: GAME.render }
  end

  def play(data)
    puts 'PLAYING'
    puts data
  end

  def start
    GAME.play
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def valid_action(action, player)
    GAME.current_player_idx == player && GAME.turn.state == action
  end
end
