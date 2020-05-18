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
  def play(card)
    raise('Invalid Move') && return unless valid_move?(card)

    @suit ||= card.suit

    if card.wild?
      card.current_suit(@suit)
      card.current_value(last_card.next_value)
    end

    cards << card
  end

  def reset
    super
    @suit = nil
  end

  # TODO: TDD
  # TODO: prevent wild from representing an invalid card value (high or low)
  # May need to prompt high/low for wild (and in rare edge cases for Aces)
  def valid_move?(card)
    # TODO: can't enforce this (second card may need to be wild)
    # if cards.length < 2
    #   return false if card.wild?
    # end

    return true if cards.empty?

    card.wild? || card.suit == suit && card.next?(last_card)
  end
end
