# frozen_string_literal: true

# TODO: this should build players by default
FactoryBot.define do
  factory :game do
    transient do
      current_player_idx { 1 }
    end

    # TODO: don't always want this
    # after(:build) do |model|
    #   model.instance_variable_set(:@turn, Turn.new(build(:player, name: 'Josh', game: model)))
    # end

    after(:build) do |model, evaluator|
      model.instance_variable_set(:@current_player_idx, evaluator.current_player_idx)
    end
  end
end
