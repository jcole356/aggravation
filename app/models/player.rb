# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/AbcSize

# Class for player logic
class Player
  attr_reader :name, :current_hand, :game

  PILE_OPTIONS = {
    d: 'Deck',
    p: 'Pile'
  }.freeze

  def initialize(name, game)
    @name = name
    @game = game
    @current_hand = 0
    @score = 0
  end

  def can_draw_from_pile?
    !hand.down && game.pile.can_draw_from_pile?
  end

  def discard(idx)
    hand.validate
    card = hand.select_card(idx)
    hand.remove_card(card)
    game.discard(card)
  end

  def draw_from_deck
    hand.cards << game.draw_from_deck
  end

  def draw_from_pile
    return unless can_draw_from_pile?

    card = game.draw_from_pile
    hand.cards << card
  end

  def get_card_from_player(coords)
    other_player = get_other_player(coords)
    other_player_pile = get_other_player_pile(other_player, coords)
    other_player_pile.cards[coords[2]]
  end

  def get_other_player(coords)
    game.players[coords[0]]
  end

  def get_other_player_pile(player, coords)
    player.hand.piles[coords[1]]
  end

  def hand(hand = nil)
    @hand ||= hand
  end

  def play(pile_idx, card_idx)
    piles = hand.piles
    pile = piles[pile_idx]
    play_card(pile, card_idx)
  end

  def play_card(pile, card_idx)
    card = hand.select_card(card_idx)
    begin
      pile.play(card)
    rescue StandardError => e
      puts e
      return
    end
    hand.remove_card(card)
  end

  def play_or_discard
    choice = nil

    until choice == :d
      choice = play_prompt

      if choice == :p
        play
        next
      elsif choice == :d
        discard
        break
      else
        invalid_selection_response
      end
    end
  end

  def render_hand
    hand.render
  end

  def render_piles
    hand.render_piles
  end

  # TODO: Need to handle undo
  # @coord: [player, pile, index]
  def swap
    card_coord = []
    # TODO: need to list the players
    player_choice_idx = swap_player_prompt
    card_coord << player_choice_idx
    player = game.players[player_choice_idx]
    puts player # TODO: remove

    pile_choice_idx = swap_pile_prompt
    pile = player.hand.piles[pile_choice_idx]
    card_coord << pile_choice_idx
    puts pile # TODO: remove

    card_choice_idx = swap_card_prompt
    card = pile.cards[card_choice_idx]
    card.render # TODO: remove

    card_coord << card_choice_idx

    puts "Card coord #{card_coord}"
    puts "You are going to steal from #{player_choice_idx}, #{pile_choice_idx} #{card_choice_idx}"
    own_card_choice = card_swap_prompt
    puts hand.cards[own_card_choice]
    puts "You chose to swap your #{own_card_choice}"
    swap_cards(hand.cards[own_card_choice], card_coord)
  end

  # TODO: might need to add a turn class with card queue
  # Swapping logic only, no prompts
  def swap_cards(card, coords)
    other_player = get_other_player(coords)
    other_player_card = get_card_from_player(coords)
    return false unless other_player_card.matches?(card)

    other_player_pile = get_other_player_pile(other_player, coords)
    other_card_index = other_player_pile.remove_card(other_player_card)
    hand.remove_card(card)
    other_player_pile.cards.insert(other_card_index, card)
    true
  end
end
