# frozen_string_literal: true

require "factory_bot"

require_relative "../api_student"

FactoryBot.define do
  factory :sygne_student, parent: :api_student do
    ine { ine_value }
    prenom { first_name }
    nom { last_name }
    dateNaissance { birthdate }
    codeSexe { biological_sex }
    niveau { "2212" }
    codeMef { "24720008ABC" }
    codeMefRatt { mef_value }
    libelleNiveau { %w[2NDE 1ERE].sample }
    libelleLongStatut { "SCOLAIRE" }
    classe { %w[2NDE6 1EREB 1EREA].sample }
    codeRegime { "" }
    codeUai { "uai" }
    dateDebSco { "2024-09-02" }
    codeStatut { "ST" }
    adhesionTransport { false }

    trait :left_establishment do
      classe { nil }
    end

    trait :closed do
      add_attribute("dateFinSco") { "2024-10-02" }
    end

    trait :changed_class do
      classe { "NOUVELLE CLASSE #{rand}" }
    end

    transient do
      mef_value { "22124210110" }
    end

    trait :irrelevant do
      mef_value { "123123" }
    end
  end
end
