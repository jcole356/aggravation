# frozen_string_literal: true

# Class for game hand
class GameHand
  attr_reader :done

  def initialize
    @done = false
  end

  def end
    @done = true
  end
end
