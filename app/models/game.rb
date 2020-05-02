# frozen_string_literal: true

# Class for game logic
class Game
  attr_reader :players, :deck, :pile, :status

  # TODO: figure out how many players require a third deck
  # TODO: add constants for maximum number of players
  def initialize
    @players = []
    @deck = Deck.new(2)
    @deck.shuffle
    @pile = Pile.new
    @status = nil
  end

  def build_hand(player)
    PlayerHand.build(player.current_hand, deck)
  end

  def deal
    players.each do |player|
      player.hand(build_hand(player))
    end
    pile.cards << draw_from_deck
  end

  def discard(card)
    pile.discard(card)
  end

  def draw_from_deck
    if deck.empty?
      deck.cards = pile.cards
      deck.shuffle
      pile.cards = []
    end
    deck.draw
  end

  def draw_from_pile
    pile.cards.pop
  end

  def number_of_players
    invalid = false
    num_players = 0
    until valid_number_of_players(num_players)
      invalid_selection_response if invalid
      num_players = number_of_players_prompt
      invalid = true
    end

    num_players
  end

  # TODO: the following
  # Figure out how to create the players dynamically
  # Turns
  # Steals
  # Borrowing
  def play
    if status != 'started'
      # num_players = number_of_players
      num_players = 3
      num_players.times do |n|
        # puts 'Please enter your name'
        name = "Player #{n + 1}"
        @players << Player.new(name, self)
      end
      deal
      @status = 'started'
    end
    ActionCable.server.broadcast 'game_notifications_channel',
                                 { type: 'render', state: render }
  end

  def render
    {
      players: render_hands,
      piles: { pile: render_pile }
    }
  end

  # TODO: render_piles
  def render_hands
    players.map do |player|
      {
        label: "#{player.name}'s cards",
        hand: PlayerHand.render(player.current_hand),
        cards: player.render_hand
      }
    end
  end

  def render_pile
    pile.last.render unless pile.empty?
  end

  def valid_number_of_players(num)
    num.positive? && num < 5
  end
end
