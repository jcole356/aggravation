# frozen_string_literal: true

# Class for handling status of steal
class Steal
  def initialize(player, first_turn)
    @player = player
    @state = 'attempted'
    @confirms = 0
    @first_turn = first_turn
  end

  # TODO: Once one person votes no
  def cancel
    @state = 'cancelled'
    # return @state
  end

  # TODO: Need to trigger the steal
  def execute
    @confirms += 1
    puts "----REQUIRED CONFIRMS - #{required_num_confirmations}"
    puts "----CONFIRMS - #{@confirms}"
    if @confirms == required_num_confirmations
      @state = 'confirmed'
    end
    @state
  end

  def required_num_confirmations
    ineligible_player_count = @first_turn ? 1 : 2
    @player.game.number_of_players - ineligible_player_count
  end
end
