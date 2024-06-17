# frozen_string_literal: true

require "sinatra"
require "sinatra/json"

module Apis
  # https://api.gouv.fr/les-api/api-annuaire-education
  class Establishments < Sinatra::Base
    set :strict_paths, false

    get "/search" do
      send_file "./data/etab.json"
    end
  end
end
