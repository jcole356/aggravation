# frozen_string_literal: true

# Super class for runs and sets
class PlayerPile
  attr_reader :num_cards, :cards

  def initialize(num_cards)
    @num_cards = num_cards
    @cards = []
  end

  def abort_play(hand)
    cards.each do |card|
      hand.cards << card
    end
    reset
  end

  def complete?
    cards.length >= num_cards
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
  end
end
