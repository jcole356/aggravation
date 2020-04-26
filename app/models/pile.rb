# frozen_string_literal: true

# Class for the discard pile
class Pile
  attr_reader :can_draw_top_card
  attr_accessor :cards

  def initialize
    @cards = []
    @can_draw_top_card = true
  end

  def can_draw_from_pile?
    !empty? && can_draw_top_card
  end

  def discard(card)
    @cards << card
    @can_draw_top_card = true
  end

  def draw
    return unless can_draw_from_pile?

    @can_draw_top_card = false
    cards.pop
  end

  def empty?
    cards.empty?
  end

  def last
    cards.last
  end
end
