# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :fregata_student, parent: :json_factory do
    id { Faker::Number.number }
    dateSortieEtablissement { left_at }
    dateSortieFormation { left_classe_at }

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
        "adressesApprenant" => adressesApprenant
      }
    end

    trait :no_addresses do
      adressesApprenant { nil }
    end

    trait :left_establishment do
      left_at { Date.yesterday.to_s }
    end

    trait :changed_class do
      classe_label { "NOUVELLE CLASSE #{rand}" }
      left_classe_at { Date.yesterday.to_s }
    end

    trait :irrelevant do
      sectionReference do
        {
          "codeMef" => "123123"
        }
      end
    end

    trait :no_ine do
      ine { nil }
    end

    transient do
      left_at { nil }
      left_classe_at { nil }

      ine { Faker::Number.number(digits: 10).to_s }

      classe_label do
        [
          "2NDE JARDINERIE",
          "2NDE ALIMENTATION BIO",
          "1ERE CONDUITE PRODUCTION",
          "1ERE CONSEIL VENTE"
        ].sample
      end

      adressesApprenant do
        [
          {
            "estPrioritaire" => true,
            "adresseIndividu" => {
              "ligne2" => "80 RUE DU TEST",
              "ligne3" => nil,
              "ligne4" => nil,
              "ligne5" => nil,
              "ligne6" => "34080 MONTPELLIER",
              "ligne7" => "FRANCE",
              "communeCodePostal" => "34080",
              "communeCodeInsee" => "34172",
              "paysCodeInsee" => "99100"
            }
          }
        ]
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
