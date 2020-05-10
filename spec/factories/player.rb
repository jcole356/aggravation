# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    name { 'Cheryl' }
    game { build(:game) }

    initialize_with { new(name, game) }
  end
end