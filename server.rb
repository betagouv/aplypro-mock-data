# frozen_string_literal: true

require "sinatra"

set :bind, "0.0.0.0"
set :logging, true

get "/list-etabs" do
  send_file "./data/fr-en-adresse-et-geolocalisation-etablissements-premier-et-second-degre.csv"
end
