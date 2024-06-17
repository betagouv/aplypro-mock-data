# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default)

require File.dirname(__FILE__) + "/apis/fregata.rb"

map "/fregata" do
  run Apis::Fregata
end
