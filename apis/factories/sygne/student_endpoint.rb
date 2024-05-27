# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

# API are just too verbose
# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :sygne_student_info, parent: :api_student do
    transient do
      status_code { "ST" }
      uai { "code UAI" }
      classe_label { "TLE PRO" }
    end

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
    scolarite do
      {
        "classe" => classe_label,
        "codeStatut" => status_code,
        "codeMefRatt" => mef_value,
        "codeUai" => uai
      }
    end

    trait :apprentice do
      status_code { "AP" }
    end

    trait :french_address do
      address_country_code { 100 }
    end

    trait :foreign_address do
      address_country_code { 109 } # guten tag
    end
  end
end
# rubocop:enable Metrics/BlockLength
