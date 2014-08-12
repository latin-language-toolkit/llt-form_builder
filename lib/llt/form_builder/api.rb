require 'sinatra/base'
require 'sinatra/respond_with'
require 'llt/form_builder'

class Api < Sinatra::Base
  register Sinatra::RespondWith

  post '/generate' do
    respond_to do |f|
      f.json {}
    end
  end
end
