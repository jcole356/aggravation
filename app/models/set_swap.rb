# frozen_string_literal: true

# Specific Logic for Sets
class SetSwap < Swap
  # Reverse the swap
  def undo
    @pile.remove_card(@card1)
    @player1.hand.cards << @card1
    @player1.hand.remove_card(@card2)
    @card2.current_value(@pile.value)
    @pile.cards.insert(@card2_coords[2], @card2)
  end

  # Validate the swap
  def valid?(pile, card1, card2)
    return false unless super

    pile.value == card1.value
  end
end
