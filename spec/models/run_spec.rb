# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Metrics/BlockLength

RSpec.describe 'Run' do
  let(:ace) { build(:ace) }
  let(:ace2) { build(:ace) }
  let(:card1) { build(:card, value: Card::VALUES[:six]) }
  let(:card2) { build(:card, value: Card::VALUES[:seven]) }
  let(:card3) { build(:card, value: Card::VALUES[:eight]) }
  let(:card4) { build(:card, value: Card::VALUES[:nine]) }
  let(:wild1) { build(:wild) }
  let(:wild2) { build(:wild) }
  let(:wild3) { build(:wild) }
  let!(:other_card_idx) { rand(5) }

  describe 'play' do
    context 'when the run is empty' do
      let!(:run) { build(:run, num_cards: 5) }

      it 'plays a wild card, without setting current value or suit' do
        run.play(wild1, 0)
        expect(wild1.current_value).to eq(nil)
        expect(run.suit).to eq(nil)
      end

      it 'plays a an ace, and sets the value as ace_low' do
        run.play(ace, other_card_idx)
        expect(ace.current_value).to eq(Card::VALUES[:ace])
        expect(run.suit).to eq(ace.suit)
      end
    end

    context 'when the run has a wild card' do
      let!(:run) { build(:run, num_cards: 5, cards: [wild1]) }

      it 'plays another wild card, without setting current value or suit' do
        run.play(wild2, other_card_idx)
        expect(wild2.current_value).to eq(nil)
        expect(wild2.current_suit).to eq(nil)
        expect(run.suit).to eq(nil)
      end

      it 'plays a face card and sets the previous wild card' do
        expect(wild1.current_value).to eq(nil)
        expect(wild1.current_suit).to eq(nil)
        run.play(card1, other_card_idx)
        expect(run.suit).to eq(card1.suit)
        expect(wild1.current_value).to eq(card1.previous_value)
        expect(wild1.current_suit).to eq(card1.suit)
      end
    end

    context 'when the run has multiple wild cards' do
      let!(:run) { build(:run, num_cards: 5, cards: [wild1, wild2]) }

      it 'plays another wild card, without setting current value or suit' do
        run.play(wild3, other_card_idx)
        expect(wild3.current_value).to eq(nil)
        expect(wild3.current_suit).to eq(nil)
        expect(wild2.current_value).to eq(nil)
        expect(wild2.current_suit).to eq(nil)
        expect(wild1.current_value).to eq(nil)
        expect(wild1.current_suit).to eq(nil)
        expect(run.suit).to eq(nil)
      end

      it 'plays a face card and sets the previous wild cards' do
        expect(wild1.current_value).to eq(nil)
        expect(wild1.current_suit).to eq(nil)
        expect(wild2.current_value).to eq(nil)
        expect(wild2.current_suit).to eq(nil)
        run.play(card1, other_card_idx)
        expect(run.suit).to eq(card1.suit)
        expect(wild2.current_value).to eq(card1.previous_value)
        expect(wild2.current_suit).to eq(card1.suit)
        expect(wild1.current_value).to eq(wild2.previous_value)
        expect(wild1.current_suit).to eq(wild2.suit)
      end
    end
  end

  describe 'valid_move?' do
    let!(:run) { build(:run, num_cards: 5, cards: [card3]) }

    it 'allows a player to play the next card in a run' do
      expect(run.valid_move?(card4)).to eq(true)
    end

    it 'allows a player to play the previous card in a run' do
      expect(run.valid_move?(card2)).to eq(true)
    end

    context 'when a run already has an ace high' do
      let!(:run) { build(:run, num_cards: 5, cards: [ace]) }

      before do
        ace.current_value(Card::SPECIAL[:ace_high])
      end

      it 'does not allow you to play another ace' do
        expect(ace.current_value).to eq(Card::SPECIAL[:ace_high])
        expect(run.valid_move?(ace2)).to eq(false)
      end
    end
  end

  describe 'valid_next?' do
    let!(:run) { build(:run, num_cards: 5, cards: [ace]) }

    before do
      ace.current_value(Card::SPECIAL[:ace_high])
    end

    context 'when there is already an ace_high' do
      it 'returns false' do
        expect(run.valid_next?(wild1)).to eq(false)
      end
    end

    context 'when the last card is a wild' do
      let!(:run) { build(:run, num_cards: 4, cards: [card1, card2, wild1]) }

      before do
        wild1.current_value(Card::VALUES[:eight])
        wild1.current_suit(card2.suit)
      end

      it 'returns true if next card is in correct sequence' do
        expect(run.valid_next?(card4)).to eq(true)
      end
    end
  end

  describe 'valid_previous?' do
    let!(:run) { build(:run, num_cards: 5, cards: [ace]) }

    before do
      ace.current_value(Card::VALUES[:ace])
    end

    context 'when there is already an ace_low' do
      it 'returns false' do
        expect(run.valid_previous?(wild1)).to eq(false)
      end
    end
  end
end
