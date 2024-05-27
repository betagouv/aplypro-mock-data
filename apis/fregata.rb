# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/namespace"

require_relative "factories/fregata"

module Apis
  class Fregata < Sinatra::Base
    set :strict_paths, false

    register Sinatra::Namespace

    namespace "/fregata" do
      get "/inscriptions" do
        json FactoryBot.build_list(:fregata_student, 10)
      end
    end
  end
end
