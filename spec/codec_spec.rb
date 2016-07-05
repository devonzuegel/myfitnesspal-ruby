# require 'bundler/setup'
# require 'rspec'

# require 'codec'

# RSpec.describe Codec do
#   let(:original_str) do
#     [
#       [0x04D3].pack('s>'),
#       [500].pack('l>'),
#       [1].pack('s>'),
#       [1].pack('s>')
#     ].join
#   end

#   let(:codec) { Codec.new(original_str) }

#   describe '#initialize' do
#     it 'should set original_str to be passed in value' do
#       expect(codec.original_str).to eq original_str
#     end
#   end

#   describe '#read_packets' do
#     it 'should return an iterator yielding BinaryPacket-subclassed objects'

#     it 'should be an iterator' do
#       expect { |b| codec.read_packets(&b) }.to yield_control
#     end
#   end

#   describe '#supported_types' do
#     it 'should support the expected types' do
#       expect(codec.supported_types).to eq(
#         1 => 'Binary::SyncRequest',
#         2 => 'Binary::SyncResult'
#       )
#     end

#     it 'should ultimately support all types'
#   end
# end
