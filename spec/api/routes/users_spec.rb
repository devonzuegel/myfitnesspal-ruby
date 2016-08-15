require 'spec_helper'

RSpec.describe API::Routes::Users do
  include Rack::Test::Methods

  let(:app) { described_class }

  it 'should require the expected keys' do
    skip

    get '/users'
    ap JSON.parse(last_response.body)
  end
end
