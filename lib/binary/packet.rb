require 'bundler/setup'
require 'abstract_method'
require 'concord'

module Binary
  # Base class for `Codec` packets. Sync API requests and responses are a
  # series of packets.
  class Packet
    # :packet_type is an integer used to associate the packet with the
    # appropriate `BinaryPacket` subclass. A packet header lists its type.
    include Concord.new(:packet_type)

    attr_reader :packet_type

    abstract_method :set_default_values
    abstract_method :read_body_from_codec
    abstract_method :write_body_to_codec
    abstract_method :to_h
    abstract_method :write_packet_to_codec

    MAGIC       = 0x04D3 # Magic number, marks the beginning of a packet.
    UUID_LENGTH = 16
    HEADER_SIZE = 10
    DATE_SIZE   = 10

    def initialize(packet_type)
      set_default_values
      super(packet_type)
    end

    def to_h
      {
        packet_type: packet_type
      }
    end

    def self.generate_uuid
      SecureRandom.hex(UUID_LENGTH / 2)
    end
  end
end
