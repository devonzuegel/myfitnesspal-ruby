RSpec.describe API::Schema::User do
  it 'returns errors when not given a username' do
    expect(described_class.call(password: 'foo').messages)
      .to eql(username: ['is missing'])
  end

  it 'returns errors when not given a password' do
    expect(described_class.call(username: 'foo').messages)
      .to eql(password: ['is missing'])
  end

  it 'returns errors when given a non-string username' do
    expect(described_class.call(username: { foo: 'bar' }, password: 'baz').messages)
      .to eql(username: ['must be a string'])
  end

  it 'returns errors when given a non-string password' do
    expect(described_class.call(username: 'baz', password: { foo: 'bar' }).messages)
      .to eql(password: ['must be a string'])
  end
end
