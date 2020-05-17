# frozen_string_literal: true

# Class for game hand
class GameHand
  attr_reader :done

  # TODO: why do I need to keep track of the dealer index here?
  def initialize(dealer_idx)
    @dealer_idx = dealer_idx
    @done = false
  end

  def end
    @done = true
  end
end
