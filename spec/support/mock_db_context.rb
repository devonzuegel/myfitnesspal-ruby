RSpec.shared_context 'mock db context', shared_context: :metadata do
  let(:db)         { Sequel.mock(host: 'postgres') }
  let(:repository) { instance_double(API::SqlRepo, db: db, to_s: 'mockuri') }

  before do
    allow(Sequel)
      .to receive(:connect)
      .and_return(Sequel.mock(host: 'postgres'))
  end
end
