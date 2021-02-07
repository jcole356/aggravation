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

  # TODO: should rename to steal_attempt
  # TODO: looks like this works for everyone except for the first hand
  # last player is treated as if they had discarded
  def steal
    theif = GAME.get_player_by_id(uuid)
    if theif.can_steal?
      # Initiate the steal
      GAME.steal(theif)
      message = "#{theif.name} would like to steal"
      GAME.players.each do |player|
        # TODO: Also need to prompt if it's the first turn of the game
        if player.can_steal? || GAME.current_player == player
          puts '-----CAN_STEAL--------'
          puts player.can_steal?
          puts '-----CURRENT PLAYER-------'
          puts GAME.current_player
          puts '------PLAYER--------'
          puts player
          puts '-------PRIORITY------'
          puts player.steal_priority
          puts theif.steal_priority
          should_prompt = theif.steal_priority < player.steal_priority || GAME.current_player == player
        end
        ActionCable.server.broadcast "player_#{player.id}",
                                     { type: 'steal',
                                       message: message,
                                       prompt: should_prompt }
      end
    end
  end

  # TODO: Needs to confirm that the player is higher priority (don't rely on the client)
  # TODO: currently, highest priority player will have to confirm for each attempt
  # We should track their confirmation instead of asking more than once.
  # TODO: clear the prompt after eash confirmation or denial
  def steal_confirm
    player = GAME.get_player_by_id(uuid)
    state = GAME&.turn&.steal&.execute
    if state === 'attempted'
      message = 'Waiting for others'
      should_prompt = false
    end
    ActionCable.server.broadcast "player_#{player.id}",
                                     { type: 'steal',
                                       message: message,
                                       prompt: should_prompt }
  end

  # TODO: Should confirm the denier has appropriate permissions to deny
  # One denial ends the current steal and either processes the current players turn
  # or steals for the person ahead
  def steal_deny
    # player = GAME.get_player_by_id(uuid)
    GAME&.turn&.steal&.cancel
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
