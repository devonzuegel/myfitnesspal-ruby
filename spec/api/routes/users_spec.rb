describe API::Routes::Users, :db do
  include Rack::Test::Methods

  let(:env)          { instance_double(API::Env, to_h: {}, repository: repository) }
  let(:app)          { described_class.new(instance_double(API::Env::Wrapper, app_env: env)) }
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
    it 'requires the expected keys' do
      get '/users/create'
      expect(JSON.parse(last_response.body))
        .to eql(missing_keys_error)
    end

    it 'returns the successfully created user' do
      get '/users/create', valid_params
      expect(JSON.parse(last_response.body))
        .to eql(valid_params)
    end

    it 'creates a new user in the repository' do
      expect { get '/users/create', valid_params }
        .to change { db[:users].count }
        .by(1)
    end
  end
end
