# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/namespace"

require_relative "factories/sygne"

module Apis
  class Sygne < Sinatra::Base
    set :strict_paths, false

    register Sinatra::Namespace

    namespace "/sygne" do
      get "/etablissements/*/eleves" do |uai|
        json FactoryBot.build_list(:sygne_student, 20, codeUai: uai)
      end

      get "/eleves/*" do |ine|
        json FactoryBot.build(:sygne_student_info, ine_value: ine)
      end

      post "/token" do
        json(
          expires_in: 600,
          token_type: "Bearer",
          access_token: "some token"
        )
      end
    end
  end
end
