describe API::Utils do
  include described_class

  describe '#symbolize_keys' do
    it 'turns string keys into symbols' do
      expect(symbolize_keys('a' => 'b')).to eql(a: 'b')
    end

    it 'does nothing to symbolized keys' do
      expect(symbolize_keys(a: 'b')).to eql(a: 'b')
    end
  end
end
