# frozen_string_literal: true

FactoryBot.define do
  factory :player_hand do
    sets { nil }
    runs { nil }

    initialize_with { new(cards, sets, runs) }
  end
end
