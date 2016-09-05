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

  it 'fails on authentication', :skip do # TODO implement HTTP stub
    params = { username: 'dummy-username', password: 'dummy-password' }
    expect(described_class.call(params, repository)).to eql(
      errors: {
        credentials: 'Authentication failed'
      }
    )
  end
end
