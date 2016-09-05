describe API::Routes::Users, :db do
  include Rack::Test::Methods

  before do
    fake_instance = instance_double(MFP::Credentials, messages: {})
    stub_const('MFP::Credentials', class_double(MFP::Credentials, new: fake_instance))
  end

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

  def response
    JSON.parse(last_response.body)
  end

  describe 'get /users/create' do
    it 'requires the expected keys' do
      get '/users/create'
      expect(response).to eql(missing_keys_error)
    end

    it 'returns the successfully created user' do
      get '/users/create', valid_params
      expect(response.reject { |x| x == 'id' }).to eql(valid_params)
      expect(response['id']).to_not be nil
    end

    it 'creates a new user in the repository' do
      expect { get '/users/create', valid_params }.to change { db[:users].count }.by(1)
    end

    it 'fails when given a duplicate username' do
      allow_any_instance_of(API::Mappers::User).to receive(:available?).and_return(false)

      get '/users/create', valid_params
      expect(response).to eql('errors' => { 'username' => ['has already been taken'] })
    end
  end
end
