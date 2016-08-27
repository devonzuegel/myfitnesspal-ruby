describe API::Schema::User::MFPAuth do
  let(:repo)           { instance_double(API::Repo::User, available?: true) }
  let(:valid_username) { 'bazz' }
  let(:valid_password) { 'foobar' }

  it 'returns a Schema::Result' do
    expect(described_class.call('uname', 'pword').class).to eql(API::Schema::Result)
  end

  it 'succeeds when given good credentials'

  it 'returns a result with appropriate error messages when given bad credentials', :skip do
    expect(described_class.call('uname', 'pword'))
      .to eql(API::Schema::Result.new({ credentials: 'Incorrect username or password' }, {}))
  end
end
