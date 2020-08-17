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
    ActionCable.server.broadcast 'game_notifications_channel',
                                 { type: 'join',
                                   state: { playerCount: GAME.players.length } }
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

  def steal
    player = GAME.get_player_by_id(uuid)
    if player.can_steal?
      GAME.steal(player)
      message = "#{player.name} would like to steal"
      ActionCable.server.broadcast 'game_notifications_channel',
                                   { type: 'steal',
                                     message: message }
    end
  end

  # TODO: I don't think we need any of this, if someone clicks to steal
  # update the message based on the priority.  Otherwise, reward the steal
  def steal_confirm
    player = GAME.get_player_by_id(uuid)
  end

  def steal_deny
    player = GAME.get_player_by_id(uuid)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  # TODO: should not verify the action based on the player sent.
  # Should use a combination of the uuid and game current player
  def valid_action(action, player)
    return false unless GAME.turn.state == action

    GAME.get_player_by_id(uuid) == GAME.players[player]
  end
end
