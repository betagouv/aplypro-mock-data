# frozen_string_literal: true

require "json"
require "sinatra"
require "sinatra/json"
require "factory_bot"

require_relative "factories/api_student"

set :bind, "0.0.0.0"
set :logging, true
set :strict_paths, false

get "/sygne/" do
  send_file "./data/sygne-students-for-uai.json"
end

get "/sygne/v1/etablissements/*/eleves" do |uai|
  json FactoryBot.build_list(:sygne_student, 40, codeUai: uai)
end

get "/sygne/v1/eleves/*" do |ine|
  json FactoryBot.build(:sygne_student_info, ine_value: ine)
end

get "/fregata/inscriptions" do
  send_file "./data/fregata-students.json"
end

get "/etab-info/search" do
  send_file "./data/etab.json"
end

post "/sygne/token" do
  json(
    expires_in: 600,
    token_type: "Bearer",
    access_token: "some token"
  )
end
