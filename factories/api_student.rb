# frozen_string_literal: true

require "faker"
require "json"

Faker::Config.locale = :fr

FactoryBot.define do
  factory :json_factory, class: "Hash" do
    initialize_with { JSON.parse(attributes.to_json) }
  end
end

require_relative "sygne"
require_relative "fregata"
