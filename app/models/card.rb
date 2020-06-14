# frozen_string_literal: true

# Class for building decks and card logic
class Card # rubocop:disable Metrics/ClassLength
  attr_reader :suit, :value

  SUITS = {
    diamonds: 'D',
    hearts: 'H',
    spades: 'S',
    clubs: 'C'
  }.freeze

  VALUES = {
    ace: 'A',
    two: '2',
    three: '3',
    four: '4',
    five: '5',
    six: '6',
    seven: '7',
    eight: '8',
    nine: '9',
    ten: '10',
    jack: 'J',
    queen: 'Q',
    king: 'K'
  }.freeze

  SPECIAL = {
    ace_high: 'AH'
  }.freeze

  WILD = {
    two: '2',
    joker: 'JOKER'
  }.freeze

  def initialize(suit, value)
    @suit = suit
    @value = value
  end

  def self.special
    SPECIAL.values
  end

  def self.suits
    SUITS.values
  end

  def self.possible_ranks
    Card.values + Card.special
  end

  def self.render_cards(cards, obfuscate = false)
    obfuscate ? cards.map { { obfuscate: obfuscate } } : cards.map(&:render)
  end

  def self.sum(cards)
    cards.inject(0) { |acc, card| acc + card.points }
  end

  def self.values
    VALUES.values
  end

  def self.wild_cards
    WILD.values
  end

  # Builds the standard deck
  def self.all_cards # rubocop:disable Metrics/MethodLength
    all_cards = []
    suits.each do |suit|
      values.each do |value|
        all_cards << if value == Card::VALUES[:two]
                       Wild.new(suit, value)
                     elsif value == Card::VALUES[:ace]
                       Ace.new(suit)
                     else
                       Card.new(suit, value)
                     end
      end
    end
    2.times { all_cards << Wild.new(nil, WILD[:joker]) }
    all_cards
  end

  def ace?
    false
  end

  def current_suit
    suit
  end

  def current_value
    value
  end

  # Arg card must have current_values established
  def matches?(card, suit = false)
    return matches_value?(card) && matches_suit?(card) if suit

    matches_value?(card)
  end

  def matches_suit?(card)
    return false unless card.current_suit

    wild? || current_suit == card.current_suit
  end

  def matches_value?(card)
    return false unless card.current_value

    wild? || current_value == card.current_value
  end

  def next_value
    Card.possible_ranks[Card.possible_ranks.index(current_value) + 1]
  end

  # Can the current card be played next in a run
  def next?(prev_card)
    return false if prev_card.current_value == Card::SPECIAL[:ace_high]

    return true if wild?

    return false unless same_suit?(prev_card)

    if ace?
      possible_values.include?(prev_card.next_value)
    else
      puts 'CHECKING RANK IN NEXT'
      rank == prev_card.rank + 1
    end
  end

  def points
    rank > 7 ? 10 : 5
  end

  # Can the current card be played first in a run
  def previous?(next_card)
    return false if next_card.current_value == Card::VALUES[:ace]

    return true if wild?

    return false unless same_suit?(next_card)

    if ace?
      possible_values.include?(next_card.next_value)
    else
      puts 'CHECKING RANK IN PREVIOUS'
      rank == next_card.rank - 1
    end
  end

  def previous_value
    Card.possible_ranks[Card.possible_ranks.index(current_value) - 1]
  end

  # Actual rank of card
  def rank
    puts 'RANK'
    puts self
    puts current_value
    value_idx = Card.possible_ranks.index(current_value)
    ranks[value_idx]
  end

  def ranks
    (1..Card.possible_ranks.length).to_a
  end

  def render
    { suit: suit, value: value }
  end

  def same_suit?(card)
    result = current_suit == card.current_suit
    puts 'SAME SUIT'
    puts result
    result
  end

  def special?
    ace? || wild?
  end

  def wild?
    false
  end
end
