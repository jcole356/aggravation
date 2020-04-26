# frozen_string_literal: true

# Class for defining run
class Run
  attr_reader :num_cards, :same_suit, :cards

  def initialize(num_cards, same_suit = false)
    @num_cards = num_cards
    @same_suit = same_suit
    @cards = []
  end
end
