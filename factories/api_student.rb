# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

Faker::Config.locale = :fr

FactoryBot.define do
  factory :sygne_student, class: OpenStruct do # rubocop:disable Style/OpenStructUse
    ine { Faker::Alphanumeric.alphanumeric(number: 10).upcase }
    prenom { Faker::Name.first_name }
    nom { Faker::Name.last_name }
    dateNaissance { Faker::Date.between(from: 20.years.ago, to: 16.years.ago).to_s }
    codeSexe { [0, 1].sample }
    niveau { "2212" }
    codeMef { "24720008310" }
    libelleNiveau { %w[2NDE 1ERE].sample }
    classe { %w[2NDE6 1EREB 1EREA].sample }
    codeRegime { "" }
    codeUai { "uai" }

    trait :gone do
      classe { nil }
    end

    trait :no_ine do
      ine { nil }
    end
  end
end

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :fregata_student, class: OpenStruct do # rubocop:disable Style/OpenStructUse
    id { Faker::Number.number }
    division do
      {
        "libelle" => classe_label
      }
    end
    sectionReference do
      {
        "codeMef" => "27621407320"
      }
    end
    apprenant do
      {
        "prenomUsuel" => Faker::Name.first_name,
        "nomUsuel" => Faker::Name.last_name,
        "dateNaissance" => Faker::Date.between(from: 20.years.ago, to: 16.years.ago).to_s,
        "ine" => ine,
        "dateSortieEtablissement" => left_at
      }
    end

    trait :gone do
      left_at { Date.yesterday.to_s }
    end

    trait :irrelevant do
      sectionReference do
        {
          "codeMef" => "123123"
        }
      end
    end

    trait :no_ine do
      apprenant do
        {
          "ine" => nil
        }
      end
    end

    transient do
      left_at { nil }

      ine { Faker::Number.number(digits: 10).to_s }

      classe_label do
        [
          "2NDE JARDINERIE",
          "2NDE ALIMENTATION BIO",
          "1ERE CONDUITE PRODUCTION",
          "1ERE CONSEIL VENTE"
        ].sample
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
