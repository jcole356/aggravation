# frozen_string_literal: true

RSpec.describe 'Swap' do # rubocop:disable Metrics/BlockLength
  let(:card1) { build(:card) }
  let(:card2) { build(:card) }
  let(:card3) { build(:card, value: Card::VALUES[:six]) }
  let(:card4) { build(:card, value: Card::VALUES[:seven]) }
  let(:card5) { build(:card, value: Card::VALUES[:eight]) }
  let(:card6) { build(:card, value: Card::VALUES[:nine]) }
  let(:card7) { build(:card, value: Card::VALUES[:ten]) }
  let(:card8) { build(:card, value: Card::VALUES[:jack]) }
  let(:wild) { build(:wild) }
  let(:set_cards) { [card1, card2, wild] }
  let(:hand_cards) { [card3, card4, card5, card6, card7, card8] }
  let!(:game) { build(:game) }
  let!(:set1) { build(:hand_set, num_cards: 3, cards: set_cards) }
  let!(:set2) { build(:hand_set, num_cards: 3, cards: set_cards) }
  let!(:player1) { build(:player, name: 'Josh', game: game) }
  let!(:player2) { build(:player, name: 'Christian', game: game, piles: [set2]) }
  let!(:player3) { build(:player, name: 'Eric', game: game) }
  let(:swap) do
    SetSwap.new(game: game, card1_coords: [0, 1], card2_coords: [1, 0, 2])
  end
  let(:hand) { build(:player_hand, cards: hand_cards, sets: [set1]) }

  before(:each) do
    expect(PlayerHand).to receive(:build_sets)
    expect(PlayerHand).to receive(:build_sets).and_return([set2])
    expect(PlayerHand).to receive(:build_sets)
    game.deal
    # Change the value of the cards in the hand
    allow(player1).to receive(:hand).and_return(hand)
  end

  describe 'execute' do
    before do
      expect(swap).to receive(:valid?).and_return(true)
    end

    it "transfers card from a player's pile to another player's hand" do
      value = player1.hand.cards.second.clone
      expect(player1.hand.cards.length).to eq(hand.cards.length)
      expect(set2.cards.length).to eq(3)
      swap.execute
      expect(player1.hand.cards.length).to eq(hand.cards.length)
      expect(set2.cards.length).to eq(3)
      expect(player1.hand.cards.last).to eq(wild)
      expect(set2.cards.last.matches?(value, true)).to eq(true)
    end
  end

  describe 'valid' do
    it 'requires the first card to match the set' do
      expect(swap.valid?(set2, card1, wild)).to eq(true)
    end

    it 'requires the second card to be wild' do
      expect(swap.valid?(set2, card1, card2)).to eq(false)
    end
  end

  describe 'undo' do
    before do
      expect(swap).to receive(:valid?).and_return(true)
    end

    it 'reverses the swap' do
      card = player1.hand.cards.second
      swap.execute
      expect(player1.hand.cards).not_to include(card)
      expect(player1.hand.cards).to include(wild)
      expect(wild.current_value).to eq(nil)
      expect(set2.cards).to include(card)
      expect(set2.cards).not_to include(wild)
      swap.undo
      expect(player1.hand.cards).to include(card)
      expect(set2.cards).not_to include(card)
      expect(player1.hand.cards).not_to include(wild)
      expect(set2.cards).to include(wild)
      expect(wild.current_value).not_to eq(nil)
    end
  end
end
