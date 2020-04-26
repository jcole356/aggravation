# frozen_string_literal: true

# Channel for player notifications
class PlayerNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'player_notifiations_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
