require 'rack'
require 'rack/protection'

# NOTE: Bypass Host Auth because we dont need it
# (using Sinatra options seemingly didnt work)
module Rack
  module Protection
    class HostAuthorization
      def call(env)
        @app.call(env)
      end
    end
  end
end

require './server'

run Sinatra::Application
