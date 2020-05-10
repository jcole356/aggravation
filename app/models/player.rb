# frozen_string_literal: true

# Class for player logic
class Player
  attr_reader :name, :current_hand, :game

  PILE_OPTIONS = {
    d: 'Deck',
    p: 'Pile'
  }.freeze

  def initialize(name, game)
    @name = name
    @game = game
    @current_hand = 0
    @score = 0
  end

  def can_draw_from_pile?
    !hand.down && game.pile.can_draw_from_pile?
  end

  # TODO: this needs to be a little more robust
  # Check for wild cards
  def can_play_on_others_hand?(other_player_idx)
    hand.down && game.players[other_player_idx].hand.down
  end

  def discard(idx)
    hand.abort_play unless hand.validate
    card = hand.select_card(idx)
    hand.remove_card(card)
    game.discard(card)
  end

  def draw_from_deck
    hand.cards << game.draw_from_deck
  end

  def draw_from_pile
    return unless can_draw_from_pile?

    card = game.draw_from_pile
    hand.cards << card
  end

  def hand(hand = nil)
    @hand ||= hand
  end

  def play(pile_idx, card_idx, other_player_idx)
    if other_player_idx
      return unless can_play_on_others_hand?(other_player_idx)

      piles = game.players[other_player_idx].hand.piles
    else
      piles = hand.piles
    end
    pile = piles[pile_idx]
    play_card(pile, card_idx)
    hand.validate
  end

  def play_card(pile, card_idx)
    card = hand.select_card(card_idx)
    begin
      pile.play(card)
    rescue StandardError => e
      puts e
      return
    end
    hand.remove_card(card)
  end

  def render_hand
    hand.render
  end

  def render_piles
    hand.render_piles
  end
end
