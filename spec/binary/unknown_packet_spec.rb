require 'bundler/setup'
require 'rspec'

require 'binary/unknown_packet'
require 'mocks/fake_codec'

RSpec.describe MFP::Binary::UnknownPacket do
  # let(:packet) { Binary::UnknownPacket.new }

  # describe '#read_body_from_codec' do
  #   it 'should be an abstract method' do
  #     expect { packet.read_body_from_codec }.to raise_error AbstractMethodCalled
  #   end
  # end

  # describe '#write_body_to_codec' do
  #   it 'should be an abstract method' do
  #     expect { packet.write_body_to_codec }.to raise_error AbstractMethodCalled
  #   end
  # end

  # describe '#to_h' do
  #   it 'should be an abstract method' do
  #     expected = {
  #       '@bytes'         => '',
  #       '@packet_length' => nil,
  #       '@packet_start'  => nil
  #     }
  #     expect(JSON.parse(packet.to_h)).to eq expected
  #   end
  # end

  # describe '#write_packet_to_codec' do
  #   it 'should be an abstract method' do
  #     expect do
  #       packet.write_packet_to_codec(FakeCodec.new)
  #     end.to raise_error AbstractMethodCalled
  #   end
  # end
end
