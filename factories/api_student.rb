# frozen_string_literal: true

require "faker"
require "json"

Faker::Config.locale = :fr

FactoryBot.define do
  factory :json_factory, class: "Hash" do
    initialize_with { JSON.parse(attributes.to_json) }
  end
end

FactoryBot.define do
  factory :api_student, parent: :json_factory do
    transient do
      ine_value { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
      biological_sex { %w[1 2].sample }
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      birthdate { Faker::Date.between(from: 20.years.ago, to: 16.years.ago).to_s }
      address_line1 { Faker::Address.street_name }
      address_line2 { Faker::Address.street_name }
      address_postal_code { Faker::Address.zip_code }
      address_city { Faker::Address.city }
      address_city_insee_code { Faker::Number.number(digits: 5).to_s }
      address_country_code { Faker::Number.number(digits: 5).to_s }
      birthplace_city_insee_code { Faker::Number.number(digits: 5).to_s }
      birthplace_country_insee_code { Faker::Number.number(digits: 5).to_s }
    end

    trait :no_ine do
      ine_value { nil }
    end

    # both SYGNE and FREGATA happen to encode this the same way
    trait :male do
      biological_sex { "1" }
    end

    trait :female do
      biological_sex { "2" }
    end
  end
end

require_relative "sygne"
require_relative "fregata"
