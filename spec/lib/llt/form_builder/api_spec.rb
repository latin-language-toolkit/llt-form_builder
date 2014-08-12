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

  describe '/generate' do
    it "generates forms" do
      post('/generate', { success: true }.to_json, json_headers)
      last_response.should be_ok
      #response = last_response.body
    end
  end
end
