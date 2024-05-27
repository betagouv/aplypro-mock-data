# frozen_string_literal: true

require "sinatra"

require_relative "apis/sygne"
require_relative "apis/fregata"

set :bind, "0.0.0.0"
set :logging, true

use Apis::Sygne
use Apis::Fregata
