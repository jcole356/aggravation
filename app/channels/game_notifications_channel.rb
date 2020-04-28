# frozen_string_literal: true

# Channel for game notifications
class GameNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'game_notifications_channel'
  end

  def draw
    puts "Time to draw a card"
  end

  def play
    GAME.play
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
