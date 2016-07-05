require 'bundler/setup'
require 'rspec'

require 'struct'

RSpec.describe Struct do
  let(:packed) do
    [
      [1].pack('s>'),
      [123].pack('l>')
    ].join
  end

  describe '#read_bytes' do
    it 'reads the expected bytes from the given bytestring' do
      short = Struct.read_bytes(packed, num_bytes: 2).unpack('s>')
      expect(short).to eq [1]

      long = Struct.read_bytes(packed, num_bytes: 4, index: 2).unpack('l>')
      expect(long).to eq [123]
    end

    it 'raises an EOFError when num_bytes > the number of bytes' do
      expect do
        Struct.read_bytes(packed, num_bytes: 20)
      end.to raise_error EOFError
    end
  end
end
