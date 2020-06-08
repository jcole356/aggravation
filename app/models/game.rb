# frozen_string_literal: true

# Class for game logic
class Game # rubocop:disable Metrics/ClassLength
  attr_reader :players, :deck, :pile, :status, :current_player_idx, :turn, :hand

  # TODO: figure out how many players require a third deck
  # TODO: add constants for maximum number of players
  def initialize
    @players = []
    @deck = Deck.new(2)
    @deck.shuffle
    @pile = Pile.new
    @status = nil
    @dealer_idx = 0
    @current_player_idx = 1
    @turn = nil
    @hand = nil
  end

  def build_hand(player)
    PlayerHand.build(player.current_hand, deck)
  end

  def deal
    players.each do |player|
      player.start_new_hand(build_hand(player))
    end
    pile.cards << deck.draw
  end

  def discard(card)
    pile.discard(card)
    if hand.done
      @players.each(&:total_score)
      next_hand
      return
    end
    @current_player_idx = (@current_player_idx + 1) % @players.count
    current_player = @players[@current_player_idx]
    @turn = Turn.new(current_player)
    current_player.turn = @turn
  end

  def draw_from_deck
    if deck.empty?
      deck.cards = pile.cards
      deck.shuffle
      pile.cards = []
    end
    card = deck.draw
    @turn.state = 'play'
    card
  end

  def draw_from_pile
    @turn.state = 'play'
    pile.draw
  end

  def get_player(idx)
    players[idx]
  end

  def next_hand
    @dealer_idx += 1
    @players.each do |player|
      player.advance_hand if player.hand.down
    end
    start_new_hand
  end

  def play
    if status != 'started'
      start_new_hand
      @status = 'started'
    end
  end

  def render
    {
      players: render_hands,
      piles: { pile: render_pile }, # TODO: nesting unecessary
      current_player: @current_player_idx,
      turn_state: @turn.state
    }
  end

  def render_hands
    players.map do |player|
      {
        label: player.name,
        hand: PlayerHand.render(player.current_hand),
        cards: player.render_hand,
        piles: player.render_piles,
        score: player.score
      }
    end
  end

  def render_pile
    pile.last.render unless pile.empty?
  end

  # TODO: randomly choose a dealer
  def start_new_hand
    @hand = GameHand.new(@dealer_idx)
    @current_player_idx = @dealer_idx + 1
    current_player = @players[@current_player_idx]
    @turn = Turn.new(current_player)
    current_player.turn = @turn
    deal
  end

  def valid_number_of_players(num)
    num.positive? && num < 5
  end
end
