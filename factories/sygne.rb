# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

FactoryBot.define do
  factory :sygne_student, parent: :api_student do
    ine { ine_value }
    prenom { first_name }
    nom { last_name }
    dateNaissance { birthdate }
    codeSexe { biological_sex }
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

    transient do
      mef { "24720008310" }
    end

    trait :irrelevant do
      mef { "123123" }
    end
  end
end

FactoryBot.define do
  factory :sygne_student_info, parent: :api_student do
    ine { ine_value }
    codeSexe { biological_sex }
    prenom1 { first_name }
    prenom2 { Faker::Name.first_name }
    prenom3 { Faker::Name.first_name }
    nomUsage { last_name }
    dateNaissance { birthdate }
    adrResidenceEle do
      {
        "adresseLigne1" => address_line1,
        "adresseLigne2" => address_line2,
        "adresseLigne3" => Faker::Address.street_name,
        "adresseLigne4" => Faker::Address.street_name,
        "codePostal" => address_postal_code,
        "libelleCommune" => address_city,
        "codeCommuneInsee" => address_city_insee_code,
        "codePays" => address_country_code
      }
    end
    inseeCommuneNaissance { birthplace_city_insee_code }
    inseePaysNaissance { birthplace_country_insee_code }
  end
end
