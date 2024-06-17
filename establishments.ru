# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default)

require "#{File.dirname(__FILE__)}/apis/establishments.rb"

map "/establishments/" do
  run Apis::Establishments
end
