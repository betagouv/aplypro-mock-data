# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :sygne_student, parent: :json_factory do
    ine { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    prenom { Faker::Name.first_name }
    nom { Faker::Name.last_name }
    dateNaissance { Faker::Date.between(from: 20.years.ago, to: 16.years.ago).to_s }
    codeSexe { [0, 1].sample }
    niveau { "2212" }
    codeMef { "24720008ABC" }
    codeMefRatt { mef }
    libelleNiveau { %w[2NDE 1ERE].sample }
    classe { %w[2NDE6 1EREB 1EREA].sample }
    codeRegime { "" }
    codeUai { "uai" }

    trait :left_establishment do
      classe { nil }
    end

    trait :changed_class do
      classe { "NOUVELLE CLASSE #{rand}" }
    end

    trait :no_ine do
      ine { nil }
    end

    transient do
      mef { "24720008310" }
    end

    trait :irrelevant do
      mef { "123123" }
    end
  end
end

FactoryBot.define do
  factory :sygne_student_info, parent: :json_factory do
    ine { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    prenom1 { Faker::Name.first_name }
    prenom2 { Faker::Name.first_name }
    prenom3 { Faker::Name.first_name }
    nomUsage { Faker::Name.last_name }
    dateNaissance { Faker::Date.between(from: 20.years.ago, to: 16.years.ago).to_s }
    adrResidenceEle do
      {
        "adresseLigne1" => Faker::Address.street_name,
        "adresseLigne2" => Faker::Address.street_name,
        "adresseLigne3" => Faker::Address.street_name,
        "adresseLigne4" => Faker::Address.street_name,
        "codePostal" => Faker::Address.zip_code,
        "libelleCommune" => Faker::Address.city,
        "codeCommuneInsee" => Faker::Number.number(digits: 4).to_s,
        "codePays" => Faker::Number.number(digits: 3).to_s
      }
    end
    inseeCommuneNaissance { "123" }
    inseePaysNaissance { "456" }
  end
end
# rubocop:enable Metrics/BlockLength
