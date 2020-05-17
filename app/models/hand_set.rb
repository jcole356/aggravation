# frozen_string_literal: true

# Class for defining set (avoids naming collision with Ruby Set)
class HandSet < PlayerPile
  attr_reader :value

  def initialize(num_cards)
    super
    @value = nil
  end

  def play(card)
    raise('Invalid Move') && return unless valid_move?(card)

    @value ||= card.value
    card.current_value(value) if card.wild?

    cards << card
  end

  def reset
    super
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
