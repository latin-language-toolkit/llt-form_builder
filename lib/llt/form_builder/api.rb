require 'sinatra/base'
require 'sinatra/respond_with'
require 'sinatra/json'
require 'json'
require 'llt/form_builder'

class Api < Sinatra::Base
  register Sinatra::RespondWith

  before do
    headers 'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => %w{ GET POST },
      'Access-Control-Allow-Headers' => %w{ Content-Type }
  end

  post '/generate' do
    request_json = JSON.parse(request.body.read)
    forms = LLT::FormBuilder.build(*request_json)
    json(forms);
  end

  options '/generate' do
  end
end
