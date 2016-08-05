require 'bundler/setup'
require 'rspec'

require 'binary/packet'

RSpec.describe MFP::Binary::Packet do
  before do
    class MyPacket < described_class
      attr_reader :packed_body

      def initialize(body)
        @packed_body = body
        super(-1)
      end

      def set_default_values; end
    end
  end

  describe '.generate_uuid' do
    it 'is the expected length of a uuid' do
      expect(described_class.generate_uuid.length).to eql described_class::UUID_LENGTH
    end
  end

  describe '#to_h' do
    it 'generates a hash from the provided attributes' do
      expect(MyPacket.new('body').to_h).to eql(packet_type: -1)
    end
  end

  describe '#packed' do
    it 'packs the header (including the body+header length) and body' do
      expect(MyPacket.new('body').packed)
        .to eql "\x04\xD3\x00\x00\x00\x0E\x00\x01\xFF\xFFbody".b

      expect(MyPacket.new('longer body').packed)
        .to eql "\x04\xD3\x00\x00\x00\x15\x00\x01\xFF\xFFlonger body".b
    end
  end
end
