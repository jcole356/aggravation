# frozen_string_literal: true

# Class to hold card swaps
class Swap
  def initialize(game:, card1_coords:, card2_coords:)
    @game = game
    @card1_coords = card1_coords # To a players hand [player_idx, card_idx]
    @card2_coords = card2_coords # To a destination pile [player_idx, pile_idx, card_idx]
    @player1 = game.players[@card1_coords[0]]
    @card1 = @player1.hand.select_card(@card1_coords[1])
    @player2 = game.players[@card2_coords[0]]
    @pile = @player2.hand.piles[@card2_coords[1]]
    @card2 = @pile.cards[@card2_coords[2]]
  end

  # Execute the swap
  def execute
    return unless valid?(@pile, @card1, @card2)

    @player1.remove_card_from_hand(@card1)
    card2_idx = @pile.find_card(@card2)
    @pile.remove_card(@card2)
    @pile.cards.insert(card2_idx, @card1)
    @card2.reset
    @player1.hand.cards << @card2
  end

  # Validate the swap
  def valid?(_pile, _card1, card2)
    card2.wild?
  end
end
