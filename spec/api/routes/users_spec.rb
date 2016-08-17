require 'spec_helper'

describe API::Routes::Users do
  include Rack::Test::Methods

  let(:app) { described_class }

  it 'should require the expected keys' # do
  #   get '/users/create'
  #   ap JSON.parse(last_response.body)
  # end
end
