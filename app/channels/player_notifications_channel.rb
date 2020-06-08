# frozen_string_literal: true

# Channel for player notifications
class PlayerNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def draw(data)
    puts 'DRAWING'
    return unless valid_action(data['action'], data['player'])

    case data['choice']
    when 'deck'
      GAME.players[data['player']].draw_from_deck
    when 'pile'
      GAME.players[data['player']].draw_from_pile
    end

    render_all
  end

  # TODO: show some status stuff while joining
  def join
    GAME.players << Player.new('Josh', GAME, uuid)
    puts 'JOINED'
    puts uuid
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  # TODO: probaby needs to check by id as well
  def valid_action(action, player)
    GAME.current_player_idx == player && GAME.turn.state == action
  end
end
