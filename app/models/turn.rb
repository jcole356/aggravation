# frozen_string_literal: true

# Class for handling player's turn
class Turn
  # TODO: Add enum for possible states
  attr_accessor :state, :swaps

  # TODO: not sure if I need the player or not
  def initialize(player)
    @player = player
    @state = 'draw'
    @swaps = []
  end
end
