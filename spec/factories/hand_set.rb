# frozen_string_literal: true

FactoryBot.define do
  factory :hand_set do
    transient do
      cards { [] }
    end

    initialize_with { new(num_cards) }

    after(:build) do |model, evaluator|
      model.instance_variable_set(:@cards, evaluator.cards)
    end
  end
end
