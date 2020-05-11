# frozen_string_literal: true

# TODO: may need more than one of these
# Swap process steps
# 1. Hand/Pile (steal wild card) add the card to the end of the hand
# and highlight the card somehow
# 2. Queue to Pile
# Class to hold card swaps
class Swap
  def initialize(game, card1_coords, card2_coords)
    @game = game
    @card1_coords = card1_coords # To a players hand [player_idx, card_idx]
    @card2_coords = card2_coords # To a desination pile [player_idx, pile_idx, card_idx]
  end

  # Execute the swap
  # Hand <> pile (player needs a card to put down, must be a wild card)
  # Hand <> pile (player borrows a card to play elsewhere, must be a wild card)
  def execute # rubocop:disable Metrics/AbcSize
    player1 = @game.players[@card1_coords[0]]
    card1 = player1.remove_card_from_hand(@card1_coords[1])
    pile = @game.players[@card2_coords[0]].hand.piles[@card2_coords[1]]
    card2 = pile.cards[@card2_coords[2]]
    card2_idx = pile.remove_card(card2)
    pile.cards.insert(card2_idx, card1)
    # TODO: this card must be a wild and it's value must be reset
    player1.hand.cards << card2
  end

  # Undo the swap
  def undo; end

  # Validate the swap
  # When player is down
  # How to handle down state (should the rules apply until they lay down, when to flip the flag)
  # When player is down cannot steal from sets anymore
  # Until player is down, can steal from anywhere
  def valid?(pile, card1, card2)
    pile.value == card1.value && card2.wild?
  end
end
