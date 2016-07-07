require 'struct'
require 'mocks/packet_mocks/raw'

RSpec.describe Struct do
  describe '#parse' do
    let(:packed) do
      [
        [1].pack('s>'),
        [20].pack('l>')
      ].join
    end

    it 'reads the expected bytes from the given bytestring' do
      parsed, rest = Struct.parse(packed, 2, 's>')
      expect(parsed).to eq 1
      expect(rest). to eq [20].pack('l>')
    end

    it 'raises an EOFError when num_bytes > the number of bytes' do
      expect { Struct.parse(packed, 20, 's>') }.to raise_error EOFError
    end
  end

  describe '#pack_short' do
    let(:val) { 3 }

    it "packs the string into MyFitnessPal's proprietary binary format" do
      expect(Struct.pack_short(val)).to eq "\x00\x03"
    end
  end

  describe '#pack_long' do
    let(:val) { 103 }

    it "packs the string into MyFitnessPal's proprietary binary format" do
      expect(Struct.pack_long(val)).to eq "\x00\x00\x00g"
    end
  end

  describe '#pack_string' do
    let(:str) { 'foobar' }

    it "packs the string into MyFitnessPal's proprietary binary format" do
      expect(Struct.pack_string(str)).to eq "\x00\x06foobar"
    end
  end

  describe '#pack_hash' do
    it "packs the hash into MyFitnessPal's proprietary binary format" do
      expect(Struct.pack_hash({ 2 => 'foobar' })).to eq PacketMocks::Raw::SIMPLE_MAP
    end
  end

  describe '#pack_method' do
    it 'detects the appropriate pack method for a string' do
      expect(Struct.pack_method('string').call('dummystr')).to eq(
        -> (val) { Struct.pack_string(val) }.call('dummystr')
      )
    end

    it 'detects the appropriate pack method for a string' do
      expect(Struct.pack_method('short').call(3)).to eq(
        -> (val) { Struct.pack_short(val) }.call(3)
      )
    end

    it 'detects the appropriate pack method for a string' do
      expect(Struct.pack_method('long').call(123)).to eq(
        -> (val) { Struct.pack_long(val) }.call(123)
      )
    end

    it 'detects the appropriate pack method for a string' do
      expect { Struct.pack_method('blah') }.to raise_error NotImplementedError
    end
  end
end
