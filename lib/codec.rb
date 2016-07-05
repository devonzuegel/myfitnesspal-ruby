require 'anima'

# Encodes and decodes MyFitnessPal binary objects.
class Codec
  include Anima.new(
    :original_str,
    :expected_packet_count,
    :packet_count,
    :position
  )

  def initialize(original_str)
    super(
      original_str:          original_str,
      expected_packet_count: nil,
      packet_count:          0,
      position:              0
    )
  end

  def read_packet
    packet_start  = position
    packet_header = read_packet_header

    packet_length = packet_header.fetch('length')

    # Calculate the expected end position of this packet. This will be
    # checked after decoding the packet.
    expected_packet_end = packet_start + packet_length

    if supported_types.include?(packet_header['type'])
    else
      fail NotImplementedError
    end

    [[true, false, false, false].sample, 'BLAH']
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

  def read_packet_header
    magic_number = read_2_byte_int
    length       = read_4_byte_int
    unknown1     = read_2_byte_int
    packet_type  = read_2_byte_int

    if magic_number != Binary::Packet::MAGIC
      fail TypeError, "Unexpected magic number #{magic_number}"
    end

    {
      'WARNING!!!!' => 'this entire hash is a dummy!', # TODO

      'magic_number' => magic_number,
      'length'       => length,
      'unknown1'     => unknown1,
      'type'         => packet_type
    }
  end

  def supported_types
    type_name_pairs = [
      Binary::SyncRequest,
      Binary::SyncResult
    ].map { |klass| [klass::PACKET_TYPE, klass.name ] }
    Hash[type_name_pairs]
  end

  def read_2_byte_int
    read_bytes(2).unpack('s>')
  end

  def read_4_byte_int
    read_bytes(4).unpack('l>')
  end

  # Return a decoded 2-byte big-endian integer.
  def read_bytes(num_bytes)
    bytes = original_str.byteslice(position, num_bytes)
    @position += num_bytes

    fail EOFError if bytes.length < num_bytes

    bytes
  end
end
