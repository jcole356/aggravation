# frozen_string_literal: true

FactoryBot.define do
  factory :card do
    suit { Card::SUITS[:diamonds] }
    value { Card::VALUES[:five] }

    initialize_with { new(suit, value) }
  end
end

FactoryBot.define do
  factory :ace do
    suit { Card::SUITS[:diamonds] }

    initialize_with { new(suit) }
  end
end

FactoryBot.define do
  factory :wild do
    suit { Card::SUITS[:diamonds] }
    value { Card::VALUES[:two] }

    initialize_with { new(suit, value) }
  end
end
