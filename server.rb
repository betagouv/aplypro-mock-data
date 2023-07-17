# frozen_string_literal: true

require "json"
require "sinatra"
require "sinatra/json"

require_relative "factories/api_student"

set :bind, "0.0.0.0"
set :logging, true

get "/sygne/" do
  send_file "./data/sygne-students-for-uai.json"
end

get "/sygne/generated/:uai" do |uai|
  json FactoryBot.build_list(:sygne_student, 40, codeUai: uai).map(&:to_h)
end

get "/sygne/generated/irrelevant_mefs" do |uai|
  json FactoryBot.build_list(:student, 40, codeUai: uai, niveau: "1111").map(&:to_h)
end

post "/sygne/token" do
  json(
    expires_in: 600,
    token_type: "Bearer",
    access_token: "some token"
  )
end
