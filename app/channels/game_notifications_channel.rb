# frozen_string_literal: true

# Channel for game notifications
class GameNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_notifications_channel'
  end

  # TODO: this should actually be on the player channel
  def draw(message)
    puts 'Time to draw a card'
    if message['choice'] == 'deck'
      GAME.players[message['player']].draw_from_deck
    end
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
