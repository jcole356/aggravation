# frozen_string_literal: true

# Channel for player notifications
class PlayerNotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def discard(data)
    puts 'DISCARDING'
    return unless valid_action('play', data['player'])

    # TODO: should send this as an int from the client if possible
    GAME.players[data['player']].discard(data['choice'].to_i)

    render_all
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
  def join(data)
    GAME.players << Player.new(data['name'], GAME, uuid)
    puts 'JOINED'
    puts uuid
  end

  def play(data)
    puts 'PLAYING'
    return unless valid_action(data['action'], data['player'])

    other_player_idx = nil
    if data['player'] != data['pile_player_idx']
      other_player_idx = data['pile_player_idx']
    end
    GAME.players[data['player']].play(
      data['pile_idx'],
      data['card_idx'],
      other_player_idx,
      data['target_card_idx']
    )

    render_all
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
