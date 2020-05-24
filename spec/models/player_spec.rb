# frozen_string_literal: true

RSpec.describe 'Player' do
  let(:card1) { build(:card) }
  let(:card2) { build(:card, value: Card::VALUES[:six]) }
  let(:card3) { build(:card, value: Card::VALUES[:seven]) }
  let(:card4) { build(:card, value: Card::VALUES[:eight]) }
  let(:cards) { [card1, card2, card3, card4] }
  let(:set) { build(:hand_set, num_cards: 3) }

  # TODO: test that you cannot discard a swap
  describe 'Player#discard' do
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
end
