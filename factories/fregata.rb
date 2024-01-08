# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :fregata_student, parent: :api_student do
    id { Faker::Number.number }
    dateSortieEtablissement { left_at&.to_date }
    dateSortieFormation { left_classe_at&.to_date }

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
        "prenomUsuel" => first_name,
        "nomUsuel" => last_name,
        "dateNaissance" => birthdate,
        "ine" => ine_value,
        "adressesApprenant" => adressesApprenant,
        "communeCodeInsee" => birthplace_city_insee_code,
        "paysCodeInsee" => birthplace_country_insee_code,
        "sexeId" => biological_sex
      }
    end

    trait :no_addresses do
      adressesApprenant { nil }
    end

    trait :left_establishment do
      left_at { Date.yesterday.to_s }
    end

    trait :left_classe do
      left_classe_at { Date.yesterday.to_s }
    end

    trait :changed_class do
      classe_label { "NOUVELLE CLASSE #{rand}" }
    end

    trait :irrelevant do
      sectionReference do
        {
          "codeMef" => "123123"
        }
      end
    end

    transient do
      left_at { nil }
      left_classe_at { nil }

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
              "ligne2" => address_line1,
              "ligne3" => address_line2,
              "ligne4" => nil,
              "ligne5" => nil,
              "ligne6" => "34080 MONTPELLIER",
              "ligne7" => "FRANCE",
              "communeCodePostal" => address_postal_code,
              "communeCodeInsee" => address_city_insee_code,
              "paysCodeInsee" => address_country_code
            }
          }
        ]
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
