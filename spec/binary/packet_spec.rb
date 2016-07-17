require 'bundler/setup'
require 'rspec'

require 'binary/packet'

RSpec.describe Binary::Packet do
  before do
    stub_const('MyPacket', Class.new(described_class))
  end
end
