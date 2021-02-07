# frozen_string_literal: true

# Class for handling player's turn
class Turn
  # TODO: Add enum for possible states
  attr_accessor :state, :swaps, :player, :steal, :first_turn

  def initialize(player, first_turn = false)
    @player = player
    @state = 'draw'
    @swaps = []
    @steal = nil
    @first_turn = first_turn
  end

  def attempt_steal(theif)
    return unless theif.can_steal?

    @steal = Steal.new(theif, @first_turn)
  end
end
