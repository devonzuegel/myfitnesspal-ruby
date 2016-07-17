require 'bundler/setup'
require 'abstract_type'
require 'concord'

module Binary
  # Base class for `Codec` packets. Sync API requests and responses are a
  # series of packets.
  class Packet
    # :packet_type is an integer used to associate the packet with the
    # appropriate `Binary::Packet` subclass. A packet header lists its type.
    include Concord::Public.new(:packet_type), AbstractType

    MAGIC       = 0x04D3 # Magic number, marks the beginning of a packet.
    UUID_LENGTH = 16
    HEADER_SIZE = 10
    DATE_SIZE   = 10

    def self.generate_uuid
      SecureRandom.hex(UUID_LENGTH / 2)
    end

    def initialize(packet_type)
      set_default_values
      super(packet_type)
    end

    abstract_method :set_default_values
    abstract_method :read_body_from_codec
    abstract_method :write_body_to_codec
    abstract_method :to_h
    abstract_method :write_packet_to_codec

    def to_h
      {
        packet_type: packet_type
      }
    end
  end
end
