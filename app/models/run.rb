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
  # TODO: this probably needs to work in both directions
  def assign_wilds(card)
    puts 'ASSIGN WILDS'
    cards.last.current_value(card.previous_value)
    cards.last.current_suit(card.suit)

    idx = cards.length - 2
    while idx >= 0
      cards[idx].current_suit(card.suit)
      cards[idx].current_value(cards[idx + 1].previous_value)
      idx -= 1
    end
  end

  def first_card
    @cards.first
  end

  def last_card
    @cards.last
  end

  # TODO: should all some specs for this
  # TODO: need to verify that the proper amount of natural cards have been played
  # TODO: need to figure out how to play on either end of the run
  # TODO: for each wild card played, you need to retroatively fix the value and suit of each
  # Once the suit is set.  Work backwards from the first normal card and set the values of the wilds
  def play(card)
    raise('Invalid Move') && return unless valid_move?(card)

    play_special(card) if card.special?

    # Set the suit unless the card is wild
    # Loop through all the wilds to fix
    if @suit.nil? && !card.wild?
      @suit = card.suit
      assign_wilds(card) unless cards.empty?
    end

    # TODO: until we accept an option here, we need to only do one
    if cards.empty? || valid_next?(card)
      cards << card
    elsif valid_previous?(card)
      cards.unshift(card)
    end
  end

  # TODO: figure out how to prompt the user for interaction (high/low)
  # - Figure out if it's high or low
  # - Determine if it's a valid play
  def play_ace(card)
    if cards.empty?
      card.current_value(Card::VALUES[:ace])
    else
      card.current_value(Card::SPECIAL[:ace_high])
    end
  end

  def play_special(card)
    if card.ace?
      play_ace(card)
    else
      play_wild(card)
    end
  end

  # TODO: when wild is played at the beginning of a hand it's current value is never set
  # TOOD: playing wild high/low is the next step
  def play_wild(card)
    card.current_value(last_card.next_value) unless cards.empty? || @suit.nil?
    card.current_suit(@suit) if @suit
  end

  def reset
    super
    @suit = nil
  end

  # TODO: prevent wild from representing an invalid card value (high or low)
  # May need to prompt high/low for wild (and in rare edge cases for Aces)
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
