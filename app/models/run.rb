# frozen_string_literal: true

# Class for defining run
class Run < PlayerPile
  attr_reader :same_suit, :suit

  def initialize(num_cards, same_suit = false)
    super(num_cards)
    @suit = nil
    @same_suit = same_suit
  end

  def first_card
    @cards.first
  end

  def last_card
    @cards.last
  end

  # TODO: need to figure out how to play on either end of the run
  # TODO: for each wild card played, you need to retroatively fix the value and suit of each
  # Once the suit is set.  Work backwards from the first normal card and set the values of the wilds
  def play(card)
    raise('Invalid Move') && return unless valid_move?(card)

    # TODO: validate that this is a valid choice
    play_special(card) if card.special?
    @suit ||= card.suit unless card.wild?

    cards << card
  end

  # TODO: figure out how to prompt the user for interaction (high/low)
  # - Figure out if it's high or low
  # - Determine if it's a valid play
  def play_ace(card)
    if cards.empty?
      card.current_value(Card::VALUES[:ace])
    else
      card.current_value(Card::SPECIAL[:ace_high])
    end
  end

  def play_special(card)
    if card.ace?
      play_ace(card)
    else
      play_wild(card)
    end
  end

  def play_wild(card)
    card.current_value(last_card.next_value)
    card.current_suit(@suit)
  end

  def reset
    super
    @suit = nil
  end

  # TODO: prevent wild from representing an invalid card value (high or low)
  # May need to prompt high/low for wild (and in rare edge cases for Aces)
  def valid_move?(card)
    return true if cards.empty?

    card.wild? || card.suit == suit && card.next?(last_card)
  end
end
