# frozen_string_literal: true

# Super class for runs and sets
class PlayerPile
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

  def reset
    @cards = []
  end
end
