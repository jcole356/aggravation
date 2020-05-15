# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Metrics/BlockLength

RSpec.describe 'Card.all_cards' do
  cards = Card.all_cards

  it 'returns a full deck of cards' do
    expect(cards.length).to eq(54)
  end

  it 'returns 2 jokers' do
    expect(cards.filter do |card|
      card.value == Card::WILD[:joker]
    end.length).to eq(2)
  end

  it 'returns 6 wild cards' do
    expect(cards.filter(&:wild?).length).to eq(6)
  end

  it 'returns 4 twos' do
    expect(cards.filter do |card|
      card.value == Card::WILD[:two]
    end.length).to eq(4)
  end

  it 'returns 4 aces' do
    expect(cards.filter { |card| card.class == Ace }.length).to eq(4)
  end
end

RSpec.describe 'Card.sum' do
  let(:ace) { build(:ace) }
  let(:wild) { build(:wild) }
  let(:card1) { build(:card, value: Card::VALUES[:six]) }
  let(:card2) { build(:card, value: Card::VALUES[:eight]) }
  let(:cards) { [ace, wild, card1, card2] }

  it 'returns the sum of an array of cards' do
    expect(Card.sum(cards)).to eq(50)
  end
end

RSpec.describe 'Card::matches?' do
  let(:card1) { build(:card) }
  let(:wild) { build(:wild) }

  it 'returns true if the cards have the same value' do
    card2 = build(:card, suit: Card::SUITS[:hearts], value: card1.value)

    expect(card1.matches?(card2)).to eq(true)
  end

  it 'returns true if one card is wild' do
    expect(wild.matches?(card1)).to eq(true)
  end

  it 'returns true if both cards are wild' do
    card2 = build(:wild, suit: nil, value: Card::WILD[:joker])
    card2.current_value(card1.value)

    expect(wild.matches?(card2)).to eq(true)
  end

  it 'returns false if one card does not match' do
    card2 = build(:card, suit: Card::SUITS[:spades], value: Card::VALUES[:three])

    expect(card1.matches?(card2)).to eq(false)
  end

  context 'when suit matters' do
    it 'returns true when the suits and values are the same' do
      card2 = build(:card, suit: card1.suit, value: card1.value)

      expect(card1.matches?(card2, true)).to eq(true)
    end

    it 'returns false when the suits are not the same' do
      wild.current_suit(Card::SUITS[:spades])
      wild.current_suit(Card::VALUES[:six])

      expect(card1.matches?(wild, true)).to eq(false)
    end
  end
end

RSpec.describe 'Card::next?' do
  let(:card1) { build(:card) }
  let(:wild) { build(:wild) }

  context 'when the card is the same suit' do
    it 'returns true if the card is the next in the sequence' do
      card2 = build(:card, value: Card::VALUES[:six])

      expect(card2.next?(card1)).to eq(true)
    end
  end

  context 'when the previous card is wild' do
    it 'returns true if the card is the next in the sequence' do
      wild.current_value(Card::VALUES[:four])
      wild.current_suit(Card::SUITS[:diamonds])

      expect(card1.next?(wild)).to eq(true)
    end
  end

  context 'when the card is wild' do
    it 'returns true' do
      wild.current_value(Card::VALUES[:six])
      wild.current_suit(Card::SUITS[:diamonds])

      expect(wild.next?(card1)).to eq(true)
    end
  end

  context 'when the card is not the same suit' do
    it 'returns false' do
      card2 = build(:card, suit: Card::SUITS[:hearts], value: Card::VALUES[:eight])

      expect(card2.next?(card1)).to eq(false)
    end
  end
end

RSpec.describe 'Card::points' do
  it 'returns the point value of the card' do
    card1 = build(:card, value: Card::VALUES[:seven])
    card2 = build(:card, value: Card::VALUES[:eight])
    card3 = build(:wild)
    card4 = build(:ace)

    expect(card1.points).to eq(5)
    expect(card2.points).to eq(10)
    expect(card3.points).to eq(20)
    expect(card4.points).to eq(15)
  end
end

RSpec.describe 'Card::rank' do
  it 'returns the rank of a standard card' do
    card = build(:card, value: Card::VALUES[:jack])

    expect(card.rank).to eq(11)
  end

  it 'returns the current rank of a wild card' do
    card = build(:wild)
    card.current_value(Card::VALUES[:three])

    expect(card.rank).to eq(3)
  end

  it 'returns the correct rank of an ace low' do
    card = build(:ace)
    card.current_value(Card::VALUES[:ace])

    expect(card.rank).to eq(1)
  end

  it 'returns the correct rank of an ace high' do
    card = build(:ace)
    card.current_value(Card::SPECIAL[:ace_high])

    expect(card.rank).to eq(14)
  end
end

RSpec.describe 'Card::same_suit?' do
  it 'returns true if the cards have the same suit' do
    card1 = build(:ace)
    card2 = build(:card, value: Card::VALUES[:jack])

    expect(card1.same_suit?(card2)).to eq(true)
  end
end

RSpec.describe 'Card::wild?' do
  it 'returns true if card is a 2' do
    card = build(:wild)

    expect(card.wild?).to eq(true)
  end

  it 'returns true if card is a joker' do
    card = build(:wild, suit: nil, value: Card::VALUES[:joker])

    expect(card.wild?).to eq(true)
  end

  it 'returns false if card is not wild' do
    card = build(:card)

    expect(card.wild?).to eq(false)
  end
end
