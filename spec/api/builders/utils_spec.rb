describe API::Builders::Utils do
  include described_class

  describe '#symbolize_keys' do
    it 'turns string keys into symbols' do
      expect(symbolize_keys('a' => 'b')).to eql(a: 'b')
    end

    it 'does nothing to already-symbolized keys' do
      expect(symbolize_keys(a: 'b')).to eql(a: 'b')
    end

    it 'recursively symbolizes kes' do
      expect(symbolize_keys('a' => { 'b' => 'c' })).to eql(a: { b: 'c' })
    end
  end

  describe '#stringify_keys' do
    it 'turns symbol keys into strings' do
      expect(stringify_keys(a: 'b')).to eql('a' => 'b')
    end

    it 'does nothing to already-stringified keys' do
      expect(stringify_keys('a' => 'b')).to eql('a' => 'b')
    end

    it 'recursively symbolizes kes' do
      expect(stringify_keys(a: { b: 'c' })).to eql('a' => { 'b' => 'c' })
    end
  end
end
