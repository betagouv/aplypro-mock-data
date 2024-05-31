# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"

# rubocop:disable Metrics/BlockLength
FactoryBot.define do
  factory :sygne_schooling_data, parent: :json_factory do
    transient do
      start_date { 2.days.ago }
      end_date { 3.days.from_now }
      classe_label { "2NDE TEST SCOLARITÉ" }
      uai { "code UAI" }
      mef_code { "code MEF" }
      school_year { Date.current.year }
      status_code { "ST" }
    end

    add_attribute("classe") { classe_label }
    add_attribute("dateDebSco") { start_date.to_date }
    add_attribute("anneeScolaire") { school_year.to_s }
    add_attribute("codeMef") { mef_code }
    add_attribute("codeUai") { uai }
    add_attribute("codeStatut") { status_code }

    trait :closed do
      add_attribute("dateFinSco") { end_date.to_date }
    end
  end

  trait :apprentice do
    status_code { "AP" }
  end

  factory :sygne_student_schoolings, parent: :api_student do
    ine { ine_value }

    transient do
      schoolings { build_list(:sygne_schooling_data, 3) }
    end

    add_attribute("scolarites") { schoolings }
  end
end
# rubocop:enable Metrics/BlockLength
