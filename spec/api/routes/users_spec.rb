describe API::Routes::Users do
  include Rack::Test::Methods

  let(:app)          { described_class.new('abcdefg 123123123') }
  let(:valid_params) { { 'username' => 'devon', 'password' => 'x' * 6 } }
  let(:missing_keys_error) do
    {
      'errors' => {
        'password' => ['is missing', 'size must be within 6 - 255'],
        'username' => ['is missing', 'size must be within 4 - 30']
      }
    }
  end

  describe 'get /users/create' do
    it 'should require the expected keys' do
      get '/users/create'
      expect(JSON.parse(last_response.body))
        .to eql(missing_keys_error)
    end

    it 'returns the successfully created user' do
      get '/users/create', valid_params
      expect(JSON.parse(last_response.body))
        .to eql(valid_params)
    end

    it 'creates a new user in the repository'
  end
end
