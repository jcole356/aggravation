# frozen_string_literal: true

FactoryBot.define do
  factory :hand_set do
    transient do
      cards { [] }
      value { nil }
    end

    initialize_with { new(num_cards) }

    after(:build) do |model, evaluator|
      cards = evaluator.cards
      unless cards.empty?
        model.instance_variable_set(:@value, cards.first.value)
      end
      model.instance_variable_set(:@cards, cards)
    end
  end
end
