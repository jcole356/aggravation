# frozen_string_literal: true

# Class for player logic
class Player
  attr_reader :name, :game, :score, :current_hand
  attr_accessor :turn

  PILE_OPTIONS = {
    d: 'Deck',
    p: 'Pile'
  }.freeze

  def initialize(name, game)
    @name = name
    @game = game
    @current_hand = 0
    @score = 0
    @turn = nil
  end

  def advance_hand
    @current_hand += 1
  end

  def can_draw_from_pile?
    !hand.down && game.pile.can_draw_from_pile?
  end

  def can_borrow_from_others_hand?(other_player_idx)
    !hand.down && game.players[other_player_idx].hand.down
  end

  def can_play_on_others_hand?(other_player_idx)
    hand.down && game.players[other_player_idx].hand.down
  end

  # TODO: If you undo swaps, you cannot allow the discard to finish
  # TODO: Can't allow discard to discard a stolen card
  def discard(idx)
    unless hand.valid?
      hand.abort_play
      @turn.swaps.each(&:undo)
    end
    hand.validate
    card = hand.select_card(idx)
    hand.remove_card(card)
    game.hand.end if hand.out?
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

  def play(pile_idx, card_idx, other_player_idx, other_card_idx)
    if other_player_idx
      play_on_others_hand(pile_idx, card_idx, other_player_idx, other_card_idx)
      return
    end
    piles = hand.piles
    pile = piles[pile_idx]
    play_card(pile, card_idx)
    game.hand.end if hand.out?
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

  # Borrow is missing the other players card_idx
  def play_on_others_hand(pile_idx, card_idx, other_player_idx, other_card_idx)
    piles = game.players[other_player_idx].hand.piles
    pile = piles[pile_idx]

    if can_play_on_others_hand?(other_player_idx)
      play_card(pile, card_idx)
    elsif can_borrow_from_others_hand?(other_player_idx)
      args = {
        game: game,
        card1_coords: [game.current_player_idx, card_idx],
        card2_coords: [other_player_idx, pile_idx, other_card_idx]
      }
      if pile.type == HandSet
        swap = SetSwap.new(args)
      elsif pile.type == Run
        swap = RunSwap.new(args)
      end
      @turn.swaps << swap
      swap.execute
    end
  end

  def remove_card_from_hand(card)
    hand.remove_card(card)
  end

  def render_hand
    hand.render
  end

  def render_piles
    hand.render_piles
  end

  def start_new_hand(hand)
    @hand = hand
  end

  def total_score
    @score += hand.score
  end
end
