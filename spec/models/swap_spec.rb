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

  before(:each) do
    expect(PlayerHand).to receive(:build_sets)
    expect(PlayerHand).to receive(:build_sets).and_return([set])
    expect(PlayerHand).to receive(:build_sets)
    game.deal
  end

  describe 'execute' do
    let(:swap) { Swap.new(game, [0, 1], [1, 0, 2]) }

    # TODO: Mocking this does not remove a card from the players hand
    before(:each) do
      expect_any_instance_of(Player).to receive(:remove_card_from_hand)
        .and_return(:card1)
    end

    # I guess it should remove the card from the players hand?
    it "transfers card from a player's pile to another player's hand" do
      expect(player1.hand.cards.length).to eq(11)
      expect(set.cards.length).to eq(3)
      swap.execute
      expect(player1.hand.cards.length).to eq(12)
      expect(set.cards.length).to eq(3)
    end
  end
end
