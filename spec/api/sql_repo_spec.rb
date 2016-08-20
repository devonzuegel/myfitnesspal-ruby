describe API::SqlRepo do
  let(:uri) { 'blah' }

  before do
    allow(Sequel)
      .to receive(:connect)
      .and_return(Sequel.mock(host: 'postgres'))
  end

  it 'connects to the Sequel database at the given uri' do
    described_class.new(uri)
    expect(Sequel).to have_received(:connect).with(uri)
  end
end
