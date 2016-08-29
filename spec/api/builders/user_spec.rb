describe API::Builders::User do
  let(:user_mapper)    { instance_double(API::Mappers::User) }
  let(:raw_params)     { { 'username' => 'blah', 'password' => 'foobar' } }
  let(:params)         { { username: 'blah', password: 'foobar' } }
  let(:failure_msgs)   { { message1: 'baz' } }
  let(:successful_val) { API::Schema::Result.new({}, params) }
  let(:failed_val)     { API::Schema::Result.new(failure_msgs, params) }

  context 'failed validation' do
    let(:validtn_klass) { class_double(API::Schema::User::Creation, call: failed_val) }

    it 'calls the provided validation & returns its errors' do
      expect(described_class.call(raw_params, validtn_klass, user_mapper))
        .to eql(errors: failure_msgs)
    end
  end

  context 'successful validation' do
    let(:validtn_klass) { class_double(API::Schema::User::Creation, call: successful_val) }
    before do
      expect(validtn_klass).to receive(:call).with(params, user_mapper)
      expect(user_mapper).to receive(:create).with(params)
    end

    it 'calls the provided validation & returns its output upon success' do
      expect(described_class.call(raw_params, validtn_klass, user_mapper))
        .to eql(params)
    end

    it 'creates a new user with validation output upon success' do
      described_class.call(raw_params, validtn_klass, user_mapper)
    end
  end
end
