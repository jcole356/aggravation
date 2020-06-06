# frozen_string_literal: true

# Class for defining run
class Run < PlayerPile
  attr_reader :same_suit, :suit

  def initialize(num_cards, same_suit = false)
    super(num_cards)
    @suit = nil
    @same_suit = same_suit
  end

  # Find all the wild cards that were played, assign them appropriately
  def assign_wilds(card, low)
    puts 'ASSIGN WILDS'
    puts low
    low ? assign_wilds_forward(card) : assign_wilds_backwards(card)
  end

  def assign_wilds_backwards(card)
    cards.last.current_value(card.previous_value)
    cards.last.current_suit(card.suit)

    idx = cards.length - 2
    while idx >= 0
      cards[idx].current_suit(card.suit)
      cards[idx].current_value(cards[idx + 1].previous_value)
      idx -= 1
    end
  end

  def assign_wilds_forward(card)
    cards.first.current_value(card.next_value)
    cards.first.current_suit(card.suit)

    idx = 1
    while idx < cards.length
      cards[idx].current_suit(card.suit)
      cards[idx].current_value(cards[idx - 1].next_value)
      idx += 1
    end
  end

  def first_card
    @cards.first
  end

  def last_card
    @cards.last
  end

  # TODO: need to verify that the proper amount of natural cards have been played
  def play(card, other_card_index)
    raise('Invalid Move') && return unless valid_move?(card)

    low = other_card_index == 0 && (card.special? || @suit.nil?) # rubocop:disable Style/NumericPredicate

    play_special(card, low) if card.special?

    # Set the suit unless the card is wild
    # Loop through all the wilds to fix
    if @suit.nil? && !card.wild?
      @suit = card.suit
      assign_wilds(card, low) unless cards.empty?
    end

    puts 'LOW'
    puts low
    if cards.empty? || (valid_next?(card) && !low)
      cards << card
    elsif valid_previous?(card)
      cards.unshift(card)
    end
  end

  def play_ace(card, low)
    puts 'PLAY_ACE'
    puts low
    if low
      card.current_value(Card::VALUES[:ace])
    else
      card.current_value(Card::SPECIAL[:ace_high])
    end
  end

  def play_special(card, low)
    if card.ace?
      play_ace(card, low)
    else
      play_wild(card, low)
    end
  end

  # TODO: checking whether or not it's empty might be redundant (no suit)
  def play_wild(card, low)
    unless cards.empty? || @suit.nil?
      new_value = low ? first_card.previous_value : last_card.next_value
      card.current_value(new_value)
    end
    card.current_suit(@suit) if @suit
  end

  def reset
    super
    @suit = nil
  end

  def valid_move?(card)
    return true if cards.empty? || @suit.nil?

    valid_next?(card) || valid_previous?(card)
  end

  # TODO: check for size of run
  def valid_next?(card)
    card.next?(last_card)
  end

  def valid_previous?(card)
    card.previous?(first_card)
  end
end
