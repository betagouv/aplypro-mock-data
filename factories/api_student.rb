# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/integer/time"
require "factory_bot"
require "faker"
require "ostruct"

Faker::Config.locale = :fr

FactoryBot.define do
  factory :sygne_student, class: OpenStruct do # rubocop:disable Style/OpenStructUse
    ine { Faker::Number.number(digits: 10) }
    prenom { Faker::Name.first_name }
    nom { Faker::Name.last_name }
    dateNaissance { Faker::Date.between(from: 20.years.ago, to: 16.years.ago) }
    codeSexe { [0, 1].sample }
    niveau { "2212" }
    codeMef { "24720008310" }
    libelleNiveau { %w[2NDE 1ERE].sample }
    classe { %w[2NDE6 1EREB 1EREA].sample }
    codeRegime { "" }
    codeUai { "uai" }
  end
end
