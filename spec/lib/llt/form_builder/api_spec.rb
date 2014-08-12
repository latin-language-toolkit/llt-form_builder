ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'llt/form_builder/api'
require 'rack/test'

def app
  Api
end

describe "segmenter api" do
  include Rack::Test::Methods

  let(:json_headers) do
    {
      "HTTP_ACCEPT" => "application/json",
      'CONTENT_TYPE' => "application/json"
    }
  end

  let(:noun_request) do
    [
      {
        type: :noun,
        stem: "ros",
        inflection_class: 1,
        sexus: :f
      }
    ].to_json
  end

  describe '/generate' do
    context "generates forms" do
      it "of nouns" do
        post('/generate', noun_request, json_headers)
        last_response.should be_ok
        #response = last_response.body
      end
    end
  end
end
