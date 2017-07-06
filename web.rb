require 'sinatra/base'

module Goatr
  class Web < Sinatra::Base
    get '/' do
      "It's a whole new Goat Rodeo"
    end

    get '/hi' do
      "Hola!!"
    end
  end
end
