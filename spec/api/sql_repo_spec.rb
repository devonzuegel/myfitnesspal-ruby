describe API::SqlRepo do
  let(:uri)      { 'blah' }
  let(:sql_repo) { described_class.new(uri) }

  before do
    allow(Sequel)
      .to receive(:connect)
      .and_return(Sequel.mock(host: 'postgres'))
  end

  describe '#initialize' do
    it 'connects to the Sequel database at the given uri' do
      described_class.new(uri)
      expect(Sequel).to have_received(:connect).with(uri)
    end

    it 'connects to a sql db' do
      expect(sql_repo.db).to eql(Sequel.mock(host: 'postgres'))
    end
  end

  describe '#to_s' do
    it 'is represented by the uri' do
      expect(sql_repo.to_s).to eql uri
    end
  end
end
