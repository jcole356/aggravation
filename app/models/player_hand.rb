# frozen_string_literal: true

# Class for the player's hand
class PlayerHand # rubocop:disable Metrics/ClassLength
  attr_reader :sets, :runs, :cards, :down

  HANDS = [
    { sets: [1, 3], runs: [1, 4] },
    { runs: [1, 4] },
    { sets: [2, 3] },
    { runs: [2, 4, true] }
  ].freeze

  def initialize(cards, sets = nil, runs = nil)
    @sets = sets
    @runs = runs
    @cards = cards
    @down = false
    @score = 0
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
    sets_string = sets.nil? ? '' : "#{sets[0]} #{'set'.pluralize(sets[0])} of #{sets[1]}"
    runs_string = runs.nil? ? '' : "#{runs[0]} #{'run'.pluralize(runs[0])} of #{runs[1]}"
    same_suit = runs && runs[3] ? ', same suit' : nil
    "#{sets_string} #{runs_string} #{same_suit}"
  end

  def abort_play
    piles.each do |pile|
      pile.abort_play(self)
    end
  end

  def max_size
    17
  end

  def out?
    cards.count.zero?
  end

  def piles
    piles = []
    piles += sets if sets
    piles += runs if runs
    piles
  end

  def render(obfuscate)
    Card.render_cards(cards, obfuscate)
  end

  # Order matters here
  def render_piles
    render_sets + render_runs
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

  def score
    Card.sum(cards)
  end

  def select_card(idx)
    cards[idx]
  end

  def remove_card(card)
    cards.delete(card)
    card
  end

  def valid?
    piles.all?(&:complete?)
  end

  def validate
    @down = valid?
  end
end
