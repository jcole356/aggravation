# frozen_string_literal: true

# Class for handling status of steal
class Steal
  def initialize(player)
    @player = player
    @state = 'attempted'
  end

  # TODO: need to player with priority to steal
  # TODO: need to handle approve deny logic
  # TODO: possible time limit
  # TODO: broadcast a message when the player steals
  def cancel

  end

  def execute
    
  end
end
