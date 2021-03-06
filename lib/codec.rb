require_relative 'struct/reader'
require_relative 'struct/packer'

require_relative 'binary/type'
require_relative 'binary/packet'
require_relative 'binary/sync_request'
require_relative 'binary/sync_response'
require_relative 'binary/user_property_update'
require_relative 'binary/measurement_types'
require_relative 'binary/food'
require_relative 'binary/meal_ingredients'
require_relative 'binary/food_entry'
require_relative 'binary/exercise'
require_relative 'binary/exercise_entry'
require_relative 'binary/water_entry'
require_relative 'binary/measurement_value'
require_relative 'binary/delete_item'

# Encodes and decodes MyFitnessPal binary objects.
module MFP
  class Codec
    include Anima.new(:original_str, :remainder), Struct::Reader, Struct::Packer

    def initialize(str)
      super(original_str: str, remainder: str)
    end

    def each_packet
      packets.each { |packet| yield packet }
    end

    def packets
      raw_packets.map { |raw_packet| read_packet(raw_packet) }
    end

    def raw_packets
      @packets = []
      @packets << read_raw_packet until remainder.empty?
      @packets
    end

    def read_raw_packet
      header      = read_packet_header
      body_length = header.fetch(:length) - Binary::Packet::HEADER_SIZE
      body, @remainder = split(remainder, body_length)
      header.merge(body: body)
    end

    def read_date
      date, @remainder = super(remainder)
      date
    end

    private

    def read_packet(raw_packet)
      type   = retrieve_type(raw_packet)
      packet = Binary::Type.supported_types.fetch(type).new
      packet.read_body_from_codec(Codec.new(raw_packet.fetch(:body)))
      packet
    end

    def read_packet_header
      {
        magic_number: read_magic_number,
        length:       read_4_byte_int,
        unknown1:     read_2_byte_int,
        type:         read_2_byte_int,
      }
    end

    def read_magic_number
      magic_number = read_2_byte_int
      return magic_number if magic_number == Binary::Packet::MAGIC
      fail TypeError, "Unexpected magic number #{magic_number}"
    end

    def retrieve_type(raw_packet)
      type = raw_packet.fetch(:type)
      return type if Binary::Type.supported_types.include?(type)
      fail NotImplementedError, "Type #{type} is not supported"
    end

    def parse(n_bytes, pack_directive)
      bytes, @remainder = super(remainder, n_bytes, pack_directive)
      bytes
    end
  end
end
