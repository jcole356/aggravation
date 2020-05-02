# frozen_string_literal: true

# Channel for game notifications
class GameNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_notifications_channel'
  end

  # TODO: this should actually be on the player channel
  def discard(data)
    puts 'DISCARDING'
    GAME.players[data['player']].discard(data['choice'].to_i)
    ActionCable.server.broadcast 'game_notifications_channel',
                                 { type: 'render', state: GAME.render }
  end

  # TODO: this should actually be on the player channel
  def draw(data)
    puts 'DRAWING'
    GAME.players[data['player']].draw_from_deck if data['choice'] == 'deck'
    ActionCable.server.broadcast 'game_notifications_channel',
                                 { type: 'render', state: GAME.render }
  end

  def play
    GAME.play
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
