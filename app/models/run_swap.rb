# frozen_string_literal: true

# Specific Logic for Sets
class RunSwap < Swap
  # Reverse the swap
  # TODO: test
  def undo
    @pile.remove_card(@card1)
    @player1.hand.cards << @card1
    @player1.hand.remove_card(@card2)
    @card2.current_value(@card1.value)
    @card2.current_suit(@pile.suit)
    @pile.cards.insert(@card2_coords[2], @card2)
  end

  # Validate the swap
  def valid?(pile, card1, card2)
    puts 'VALIDATING RUN SWAP'
    puts "Pile Suit = #{pile.suit}"
    puts "Card1 Suit = #{card1.suit}"
    puts "Card1 Value = #{card1.value}"
    puts "Card2 Current Value = #{card2.current_value}"
    result = super && pile.suit == card1.suit && card2.current_value == card1.value
    puts "RUN SWAP VALID = #{result}"
    result
  end
end
