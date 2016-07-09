require 'bundler/setup'
require 'rspec'

require 'binary/packet'

RSpec.describe Binary::Packet do
  let(:packet) { Binary::Packet.new(123) }

  describe '#new' do
    it 'should raise an AbstractMethodCalled error' do
      expect { packet }.to raise_error AbstractMethodCalled
    end
  end

  describe '#set_default_values' do
    it 'should be an abstract method' do
      expect { packet.set_default_values }.to raise_error AbstractMethodCalled
    end
  end

  describe '#read_body_from_codec' do
    it 'should be an abstract method' do
      expect { packet.read_body_from_codec }.to raise_error AbstractMethodCalled
    end
  end

  describe '#write_body_to_codec' do
    it 'should be an abstract method' do
      expect { packet.write_body_to_codec }.to raise_error AbstractMethodCalled
    end
  end

  describe '#to_h' do
    it 'should be an abstract method' do
      expect { packet.to_h }.to raise_error AbstractMethodCalled
    end
  end

  describe '#write_packet_to_codec' do
    it 'should be an abstract method' do
      codec = nil
      expect { packet.write_packet_to_codec(codec) }.to raise_error AbstractMethodCalled
    end
  end
end
