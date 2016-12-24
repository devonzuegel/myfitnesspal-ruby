describe API::Routes::Summary, :db do
  include Rack::Test::Methods

  before do
    fake_instance = instance_double(MFP::Credentials, messages: {})
    stub_const('MFP::Credentials', class_double(MFP::Credentials, new: fake_instance))
  end

  let(:env) { instance_double(API::Env, to_h: {}, repository: repository) }
  let(:app) { described_class.new(instance_double(API::Env::Wrapper, app_env: env)) }

  def response
    JSON.parse(last_response.body)
  end

  describe 'get /' do
    it 'requires the expected keys' do
      get '/'
      expect(response).to eql(
        'food_entries'   => 0,
        'food_portions'  => 0,
        'foods'          => 0,
        'last_sync_info' => 0,
        'users'          => 0,
      )
    end

    describe 'after some records have been inserted' do
      let(:food_id)    { 3 }
      let(:portion_id) { 2 }
      let(:user_id)    { 2 }

      before do
        db[:foods].insert(
          master_food_id: 123,
          description:    'dummy description',
          brand:          'dummy brand',
          calories:       1.0,
          grams:          1.0,
          id:             food_id
        )
        db[:food_portions].insert(
          id:            portion_id,
          options_index: 1,
          description:   'dummy description',
          amount:        1.0,
          gram_weight:   1.0,
          food_id:       food_id
        )
        db[:users].insert(
          id:       user_id,
          username: 'dummy-username',
          password: 'dummy-password'
        )
      end

      it 'requires the expected keys' do
        get '/'
        expect(response).to eql(
          'food_entries'   => 0,
          'food_portions'  => 1,
          'foods'          => 1,
          'last_sync_info' => 0,
          'users'          => 1,
        )
      end
    end
  end
end
