# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective
# rubocop:disable Metrics/BlockLength

RSpec.describe 'Game' do
  let(:game) { build(:game) }

  before(:each) do
    %w[a b c].each { |n| build(:player, name: n, game: game) }
  end

  describe 'Game.initialize' do
    it 'has 2 decks of cards' do
      expect(game.deck.cards.length).to eq(108)
    end
  end

  describe 'Game#deal' do
    it 'deals the player 11 cards' do
      game.deal

      expect(game.players.length).to eq(3)
      game.players.each do |player|
        expect(player.hand.cards.length).to eq(11)
      end
    end
  end

  describe 'Game#draw_from_deck' do
    context 'when the deck is not empty' do
      it 'takes the top card from the deck' do
        expect { game.draw_from_deck }.to change { game.deck.cards.length }
          .by(-1)
      end

      it 'does not call shuffle' do
        expect(game.deck).to_not receive(:shuffle)
        expect { game.draw_from_deck }.to change { game.deck.cards.length }
          .by(-1)
      end
    end

    context 'when the deck is empty' do
      before do
        until game.deck.empty?
          card = game.draw_from_deck
          game.discard(card)
        end
      end

      it 'replaces the deck with the pile and calls shuffle' do
        expect(game.deck.empty?).to eq(true)
        expect(game.pile.empty?).to eq(false)
        expect(game.deck).to receive(:shuffle)
        expect { game.draw_from_deck }
          .to change { game.deck.cards.length }
          .by(game.pile.cards.length - 1)
      end
    end
  end
end
