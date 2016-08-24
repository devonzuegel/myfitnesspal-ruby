describe API::Env do
  let(:db)         { Sequel.mock(host: 'postgres') }
  let(:repository) { instance_double(API::SqlRepo, db: db, to_s: 'mockuri') }
  let(:env)        { described_class.new(repository: repository) }

  it 'initializes with a repository' do
    expect(env.repository).to eql repository
  end

  describe '#to_h' do
    it 'provides a string representation of the environment' do
      expect(env.to_h).to eql(repository: 'mockuri')
    end
  end
end
