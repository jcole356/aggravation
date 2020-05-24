# frozen_string_literal: true

# Special Card class for Aces
class Ace < Card
  def initialize(suit, value = Card::VALUES[:ace])
    super
    @current_value = nil
  end

  def ace?
    true
  end

  def current_value(value = nil)
    @current_value = value if possible_values.include?(value)

    @current_value
  end

  def points
    15
  end

  def possible_values
    [Card::VALUES[:ace], Card::SPECIAL[:ace_high]]
  end

  def rank
    super(current_value)
  end
end
