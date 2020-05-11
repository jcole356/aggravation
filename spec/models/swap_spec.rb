# frozen_string_literal: true

RSpec.describe 'Swap' do # rubocop:disable Metrics/BlockLength
  let!(:game) { build(:game) }
  let!(:set) { build(:hand_set, num_cards: 3, cards: [card2, card3, wild]) }
  let!(:player1) { build(:player, name: 'Josh', game: game) }
  let!(:player2) { build(:player, name: 'Christian', game: game, piles: [set]) }
  let!(:player3) { build(:player, name: 'Eric', game: game) }
  let(:card1) { build(:card) }
  let(:card2) { build(:card) }
  let(:card3) { build(:card) }
  let(:wild) { build(:wild) }
  let(:swap) { Swap.new(game, [0, 1], [1, 0, 2]) }

  before(:each) do
    expect(PlayerHand).to receive(:build_sets)
    expect(PlayerHand).to receive(:build_sets).and_return([set])
    expect(PlayerHand).to receive(:build_sets)
    game.deal
  end

  # TODO: test that the cards are correct
  describe 'execute' do
    it "transfers card from a player's pile to another player's hand" do
      expect(player1.hand.cards.length).to eq(11)
      expect(set.cards.length).to eq(3)
      swap.execute
      expect(player1.hand.cards.length).to eq(11)
      expect(set.cards.length).to eq(3)
      expect(player1.hand.cards.last).to eq(wild)
      # expect(set.cards.last).to eq(card1)
    end
  end

  describe 'valid' do
    it 'requires the first card to match the set' do
      expect(swap.valid?(set, card1, wild)).to eq(true)
    end

    it 'requires the second card to be wild' do
      expect(swap.valid?(set, card1, card2)).to eq(false)
    end
  end
end
