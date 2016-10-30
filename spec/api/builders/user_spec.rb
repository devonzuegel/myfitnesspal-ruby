describe API::Builders::User, :db do
  it 'has the expected VALIDATION_CLASS' do
    expect(described_class::VALIDATION_CLASS).to eql(API::Schema::User::Creation)
  end

  it 'has the expected MAPPER_CLASS' do
    expect(described_class::MAPPER_CLASS).to eql(API::Mappers:: User)
  end

  it 'inherits from Base' do
    expect(described_class).to be < API::Builders::Base
  end

  it 'returns errors when given no username or password' do
    expect(described_class.call({}, repository)).to eql(
      errors: {
        password: [
          'is missing',
          'size must be within 6 - 255'
        ],
        username: [
          'is missing',
          'size must be within 4 - 30'
        ]
      }
    )
  end

  context 'failed authentication' do
    let(:msgs) { { credentials: 'Bad credentials!' } }

    before do
      stub_const(
        'API::Schema::User::MFPAuth',
        class_double(API::Schema::User::MFPAuth, call: API::Schema::Result.new(msgs, {}))
      )
    end

    it 'returns errors' do
      params = { username: 'dummy-username', password: 'dummy-password' }
      expect(described_class.call(params, repository)).to eql(errors: msgs)
    end
  end

  context 'successful validation' do
    before do
      fake_result = API::Schema::Result.new({}, {})
      fake_auth   = class_double(API::Schema::User::MFPAuth, call: fake_result)
      stub_const('API::Schema::User::MFPAuth', fake_auth)
    end

    it 'returns errors' do
      params = { username: 'dummy-username', password: 'dummy-password' }
      expect_any_instance_of(described_class::MAPPER_CLASS).to receive(:create).once
      described_class.call(params, repository)
    end
  end
end
