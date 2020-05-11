# frozen_string_literal: true

# TODO: this should build players by default
FactoryBot.define do
  factory :game do
    after(:build) do |model|
      model.instance_variable_set(:@turn, Turn.new(Player.new('Josh', model)))
    end
  end
end
