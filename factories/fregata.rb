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
    dateEntreeEtablissement { Date.new(2020, 1, 1).to_s }
    dateEntreeFormation { Date.new(2020, 1, 1).to_s }
    dateSortieEtablissement { left_at&.to_date }
    dateSortieFormation { left_classe_at&.to_date }
    statutApprenant do
      {
        "code" => status_code
      }
    end

    division do
      {
        "libelle" => classe_label
      }
    end
    sectionReference do
      {
        "codeMef" => mef_value
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

    trait :apprentice do
      status_code { "2503" }
    end

    transient do
      left_at { nil }
      left_classe_at { nil }
      mef_value { "27121010210" }

      # @emaildoc:
      #   Voici le dictionnaire des valeurs possibles pour ce statut de l'apprenant:
      #
      #   id      code           libelleCourt    libelleLong
      #   1        "0000"        "Etudiant"      "Etudiant"
      #   2        "2501"        "Elève"         "Elève"
      #   3        "2502"        "Adulte"        "Adulte"
      #   4        "2503"        "Apprenti"      "Apprenti"
      #   5        "2504"        "FAD"           "Formation à distance"
      #   6        "2505"        "Non scolarisé" "Non scolarisé"
      #   7        "2506"        "VAE"           "Validation des acquis d'expérience"
      status_code { "2501" }

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
