# frozen_string_literal: true

# Class for the player's hand
class PlayerHand
  attr_reader :sets, :runs, :cards
  attr_accessor :down

  HANDS = [
    { sets: [2, 3] },
    { runs: [2, 4, true] }
  ].freeze

  def initialize(cards, sets = nil, runs = nil)
    @sets = sets
    @runs = runs
    @cards = cards
    @down = false
  end

  # Factory method
  def self.build(hand_idx, deck)
    current_hand = PlayerHand::HANDS[hand_idx]
    sets = build_sets(current_hand[:sets])
    runs = build_runs(current_hand[:runs])
    new(deck.cards.slice!(0, 11), sets, runs)
  end

  # TODO: add tests
  def self.build_runs(runs)
    return nil if runs.nil?

    result = []
    runs.first.times do
      result << Run.new(runs[1], runs[2])
    end
    result
  end

  # TODO: add tests
  def self.build_sets(sets)
    return nil if sets.nil?

    result = []
    sets.first.times do
      result << HandSet.new(sets[1])
    end
    result
  end

  def self.render(hand_idx)
    current_hand = PlayerHand::HANDS[hand_idx]
    sets = current_hand[:sets]
    runs = current_hand[:runs]
    sets_string = sets.nil? ? sets : "#{sets[0]} sets of #{sets[1]}"
    runs_string = runs.nil? ? runs : ", #{runs[0]} runs of #{runs[1]}"
    same_suit = runs && runs[3] ? ' same suit' : nil
    "#{sets_string}#{runs_string}#{same_suit}"
  end

  def max_size
    17
  end

  def piles
    piles = []
    piles += sets if sets
    piles += runs if runs
    piles
  end

  def render
    Card.render_cards(cards)
  end

  # TODO: write some tests
  def render_piles
    render_runs + render_sets
  end

  # TODO: same suit
  def render_runs
    return [] if runs.nil?

    runs.map do |run|
      {
        label: "Run of #{run.num_cards}",
        cards: Card.render_cards(run.cards)
      }
    end
  end

  def render_sets
    return [] if sets.nil?

    sets.map do |set|
      {
        label: "Set of #{set.num_cards}",
        cards: Card.render_cards(set.cards)
      }
    end
  end

  def select_card(idx)
    cards[idx]
  end

  def remove_card(card)
    cards.delete(card)
    card
  end

  def validate
    piles.each do |pile|
      pile.abort_play(self) unless pile.complete?
    end
    @down = true if piles.all?(&:complete?)
  end
end
