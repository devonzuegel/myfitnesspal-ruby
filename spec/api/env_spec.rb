describe API::Env do
  let(:repository) { instance_double(API::SqlRepo, db: Sequel.mock(host: 'postgres')) }
  let(:env)        { described_class.new(repository: repository) }

  it 'initializes with a repository' do
    expect(env.repository).to eql repository
  end
end
