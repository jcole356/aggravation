# frozen_string_literal: true

RSpec.describe 'Run' do
  # let(:card1) { build(:card) }
  let(:card2) { build(:card, value: Card::VALUES[:six]) }
  let(:card3) { build(:card, value: Card::VALUES[:seven]) }
  let(:card4) { build(:card, value: Card::VALUES[:eight]) }
  let(:card5) { build(:card, value: Card::VALUES[:nine]) }
  # let(:card6) { build(:card, value: Card::VALUES[:ten]) }
  # let(:card7) { build(:card, value: Card::VALUES[:jack]) }
  # let(:wild) { build(:wild) }
  let(:run) { build(:run, num_cards: 5, cards: [card4]) }

  describe 'valid_move?' do
    it 'allows a player to play the next card in a run' do
      expect(run.valid_move?(card5)).to eq(true)
    end

    it 'allows a player to play the previous card in a run' do
      expect(run.valid_move?(card3)).to eq(true)
    end
  end
end
