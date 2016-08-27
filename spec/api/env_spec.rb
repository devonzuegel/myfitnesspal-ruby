describe API::Env do
  let(:db)         { Sequel.mock(host: 'postgres') }
  let(:repository) { instance_double(API::SqlRepo, db: db, to_s: 'mockuri') }
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
