# frozen_string_literal: true

RSpec.describe 'Player' do
  let(:card1) { build(:card) }
  let(:card2) { build(:card, value: Card::VALUES[:six]) }
  let(:card3) { build(:card, value: Card::VALUES[:seven]) }
  let(:card4) { build(:card, value: Card::VALUES[:eight]) }
  let(:cards) { [card1, card2, card3, card4] }
  let(:set) { build(:hand_set, num_cards: 3) }

  # TODO: test that you cannot discard a swap
  describe 'discard' do
    let(:hand) { build(:player_hand, cards: cards, sets: [set]) }
    let(:player) { build(:player) }

    before(:each) do
      player.hand(hand)
      expect(hand).to receive(:valid?).twice.and_return(true)
      allow(player.game).to receive(:discard)
    end

    it 'removes the card from the players hand' do
      expect { player.discard(1) }.to change { hand.cards.count }.by(-1)
    end
  end

  describe 'steal_priority' do
    let!(:player1) { build(:player, name: 'Freddy', game: game) }
    let!(:player2) { build(:player, name: 'Jason', game: game) }
    let!(:player3) { build(:player, name: 'Michael', game: game) }
    let!(:player4) { build(:player, name: 'Jigsaw', game: game) }

    context 'when the current player idx is 0' do
      let!(:game) { build(:game, current_player_idx: 0) }

      it 'returns 0 for the current player' do
        puts game.players.length
        expect(player1.steal_priority).to eq(0)
      end

      it 'returns 0 for the player who discarded' do
        expect(player4.steal_priority).to eq(0)
      end

      it 'returns the correct value for the first eligible theif' do
        expect(player2.steal_priority).to eq(2)
      end

      it 'returns the correct value for the second eligible theif' do
        expect(player3.steal_priority).to eq(1)
      end
    end

    context 'when the current player idx is 3' do
      let!(:game) { build(:game, current_player_idx: 3) }

      it 'returns 0 for the current player' do
        puts game.players.length
        expect(player4.steal_priority).to eq(0)
      end

      it 'returns 0 for the player who discarded' do
        expect(player3.steal_priority).to eq(0)
      end

      it 'returns the correct value for the first eligible theif' do
        expect(player1.steal_priority).to eq(2)
      end

      it 'returns the correct value for the second eligible theif' do
        expect(player2.steal_priority).to eq(1)
      end
    end
  end
end
