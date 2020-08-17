# frozen_string_literal: true

# Class for handling player's turn
class Turn
  # TODO: Add enum for possible states
  attr_accessor :state, :swaps, :player, :steal

  def initialize(player)
    @player = player
    @state = 'draw'
    @swaps = []
    @steal = nil
  end

  def attempt_steal(theif)
    @steal = Steal.new(theif)
  end
end
