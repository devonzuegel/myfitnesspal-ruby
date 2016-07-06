require 'bundler/setup'
require 'rspec'
require 'colorize'

require 'struct'

RSpec.describe Struct do
  let(:packed) do
    [
      [1].pack('s>'),
      [20].pack('l>')
    ].join
  end

  describe '#parse' do
    it 'reads the expected bytes from the given bytestring' do
      parsed, rest = Struct.parse(packed, 2, 's>')
      expect(parsed).to eq 1
      expect(rest). to eq [20].pack('l>')
    end

    it 'raises an EOFError when num_bytes > the number of bytes' do
      expect { Struct.parse(packed, 20, 's>') }.to raise_error EOFError
    end
  end
end
