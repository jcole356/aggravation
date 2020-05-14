# frozen_string_literal: true

# Class for defining set (avoids naming collision with Ruby Set)
class HandSet
  attr_reader :num_cards, :cards, :value

  def initialize(num_cards)
    @num_cards = num_cards
    @cards = []
    @value = nil
  end

  # TODO: might end up sharing with run class
  # When the player can't put down, cards are returned to their hand
  def abort_play(hand)
    cards.each do |card|
      hand.cards << card
    end
    reset
  end

  def complete?
    cards.length >= num_cards
  end

  def play(card)
    raise('Invalid Move') && return unless valid_move?(card)

    @value ||= card.value
    card.current_value(value) if card.wild?

    cards << card
  end

  def find_card(card)
    cards.index(card)
  end

  # Returns the index, but I think it should return the card
  def remove_card(card)
    cards.delete(card)
  end

  def reset
    @cards = []
    @value = nil
  end

  def valid_move?(card)
    if cards.length < 2
      return false if card.wild?
    end

    return true if cards.empty?

    card.wild? || card.value == value
  end
end
