describe API::Schema::User::MFPAuth do
  let(:creds) { { username: 'uname', password: 'pword' } }
  let(:repo)  { instance_double(API::Mappers::User, available?: true) }

  let(:successful_checker) do
    fake_instance = instance_double(MFP::Credentials, messages: {})
    class_double(MFP::Credentials, new: fake_instance)
  end

  let(:msgs) { { username: ['has already been taken'] } }
  let(:failed_checker) do
    fake_instance = instance_double(MFP::Credentials, messages: msgs)
    class_double(MFP::Credentials, new: fake_instance)
  end

  it 'succeeds when given good credentials' do
    expect(described_class.call(creds, repo, successful_checker))
      .to eql(API::Schema::Result.new({}, {}))
  end

  it 'returns a result with appropriate error messages when given bad credentials' do
    expect(described_class.call(creds, repo, failed_checker))
      .to eql(API::Schema::Result.new(msgs, {}))
  end

  it 'fails when given a duplicate username' do
    duplicate_repo = instance_double(API::Mappers::User, available?: false)
    expect(described_class.call(creds, duplicate_repo, failed_checker).messages)
      .to eql(username: ['has already been taken'])
    expect(duplicate_repo).to have_received(:available?).with(creds)
  end
end
