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
      model.instance_variable_set(:@suit, cards.first.suit) unless cards.empty?
      model.instance_variable_set(:@cards, cards)
    end
  end
end
