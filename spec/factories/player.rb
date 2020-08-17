# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    name { 'Cheryl' }
    game { build(:game) }
    id { SecureRandom.uuid }

    transient do
      piles { [] }
    end

    initialize_with { new(name, game, id) }

    after(:build) do |model|
      model.game.players << model
    end
  end
end
