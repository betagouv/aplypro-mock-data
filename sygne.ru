# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default)

require File.dirname(__FILE__) + "/apis/sygne.rb"

map "/sygne" do
  run Apis::Sygne
end
