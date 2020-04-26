# frozen_string_literal: true

# Class to buid and manage deck of cards
class Deck
  attr_accessor :cards

  def initialize(num_decks)
    @num_decks = num_decks
    @cards = []
    num_decks.times do
      @cards += Card.all_cards
    end
  end

  def draw
    cards.shift
  end

  def empty?
    cards.empty?
  end

  def shuffle
    @cards.shuffle!
  end
end
