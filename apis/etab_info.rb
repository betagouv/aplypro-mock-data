# frozen_string_literal: true

require "sinatra"
require "sinatra/json"
require "sinatra/namespace"

module Apis
  class EtabInfo < Sinatra::Base
    set :strict_paths, false

    register Sinatra::Namespace

    namespace "/etab-info" do
      get "/*" do
        etab_data = JSON.parse(File.read("data/etab.json"))
        json etab_data
      end
    end
  end
end
