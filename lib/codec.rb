require 'anima'
require 'struct'

require 'binary/packet'
require 'binary/sync_request'

# Encodes and decodes MyFitnessPal binary objects.
class Codec
  include Anima.new(
    :original_str,
    :remainder,
    :expected_packet_count,
    :packet_count,
    :position
  )

  def initialize(original_str)
    super(
      original_str:          original_str,
      remainder:             original_str,
      expected_packet_count: nil,
      packet_count:          0,
      position:              0
    )
  end

  def read_packet
    length = packet_header.fetch(:length)
    type   = packet_header.fetch(:type)
    # expected_packet_end = position + length

    fail NotImplementedError unless supported_types.include?(type)

    packet = supported_types.fetch(type).new(position, length)

    [[true, false, false, false].sample, packet]
  end

  def read_packets
    loop do
      eof, packet = read_packet
      break if eof
      yield packet
    end

    return if expected_packet_count?

    msg = "Expected #{expected_packet_count} objects, received #{packet_count}"
    fail Exception msg
  end

  def expected_packet_count?
    expected_packet_count.nil? || expected_packet_count == packet_count
  end

  def packet_header
    @header ||= {
      magic_number: read_2_byte_int,
      length:       read_4_byte_int,
      unknown1:     read_2_byte_int,
      type:         read_2_byte_int
    }

    if @header.fetch(:magic_number) != Binary::Packet::MAGIC
      fail TypeError, "Unexpected magic number #{@header.fetch(:magic_number)}"
    end

    @header
  end

  def supported_types
    type_name_pairs = [
      Binary::SyncRequest
    ].map { |klass| [klass::PACKET_TYPE, klass] }
    Hash[type_name_pairs]
  end

  private

  def read_2_byte_int
    read_bytes(2, 's>')
  end

  def read_4_byte_int
    read_bytes(4, 'l>')
  end

  def read_bytes(n_bytes, pack_directive)
    parsed = Struct.parse(remainder, n_bytes, pack_directive)
    bytes, @remainder = parsed
    bytes
  end
end
