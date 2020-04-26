# frozen_string_literal: true

# Special Card class for Aces
class Ace < Card
  def initialize(suit, value = Card::VALUES[:ace])
    super
    @current_value = nil
  end

  def current_value(value = nil)
    @current_value ||= value
  end

  def points
    15
  end

  def rank
    super(current_value)
  end
end
