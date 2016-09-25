describe API::Env, :mock_db do
  let(:env) do
    described_class.new(
      repository: repository,
      secret:     'mocksecret',
      rack_env:   'mockrackenv',
      favicon:    'favicon_path'
    )
  end

  it 'initializes with a repository' do
    expect(env.repository).to eql repository
  end

  it 'initializes with a secret' do
    expect(env.secret).to eql 'mocksecret'
  end

  it 'initializes with a rack_env' do
    expect(env.rack_env).to eql 'mockrackenv'
  end

  describe '#to_h' do
    it 'provides a string representation of the environment' do
      expect(env.to_h).to eql(
        repository: 'mockuri',
        secret:     'mocksecret',
        rack_env:   'mockrackenv',
        favicon:    'favicon_path'
      )
    end
  end
end
