# frozen_string_literal: true

require "json"
require "sinatra"
require "sinatra/json"

require_relative "factories/student"

set :bind, "0.0.0.0"
set :logging, true

get "/list-etabs" do
  send_file "./data/fr-en-adresse-et-geolocalisation-etablissements-premier-et-second-degre.csv"
end

get "/list-mefstats" do
  send_file "./data/en_n_mef_stat4_vu1_1_0-1.csv"
end

get "/sygne/" do
  send_file "./data/sygne-students-for-uai.json"
end

get "/sygne/generated/:uai" do |uai|
  json FactoryBot.build_list(:student, 40, codeUai: uai).map(&:to_h)
end
