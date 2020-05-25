# frozen_string_literal: true

FactoryBot.define do
  factory :run do
    transient do
      cards { [] }
      suit { nil }
    end

    initialize_with { new(num_cards) }

    after(:build) do |model, evaluator|
      cards = evaluator.cards
      suit = cards.empty? || cards.first.wild? ? nil : cards.first.suit
      model.instance_variable_set(:@suit, suit)
      model.instance_variable_set(:@cards, cards)
    end
  end
end
