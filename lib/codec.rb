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

  UUID_LENGTH = 16

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
    type               = packet_header.fetch(:type)
    length             = packet_header.fetch(:length)
    expected_remainder = remainder[length, -1]
    fail NotImplementedError unless supported_types.include?(type)


    klass  = supported_types.fetch(type)
    packet = klass.new(position, length)

    packet.read_body_from_codec(self)
    update_packet_count(packet)

    changeme = [true, false, false, false]
    return [changeme.sample, packet] if remainder != expected_remainder

    fail Error <<~HEREDOC
      Packet read finished with remainder "#{remainder}", but expected it to
      to be "#{expected_remainder}"
    HEREDOC
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

  def read_2_byte_int
    read_bytes(2, 's>')
  end

  def read_4_byte_int
    read_bytes(4, 'l>')
  end

  def read_uuid
    read_string(UUID_LENGTH)
  end

  def read_string(str_length = nil)
    str_length ||= read_2_byte_int
    str          = remainder[0..str_length]
    @remainder   = remainder[str_length..remainder.length]

    str
  end

  private

  def read_bytes(n_bytes, pack_directive)
    bytes, @remainder = Struct.parse(remainder, n_bytes, pack_directive)
    bytes
  end

  def update_packet_count(packet)
    if packet.class == Binary::SyncRequest
      @expected_packet_count = packet.expected_packet_count
    else
      @packet_count += 1
    end
  end
end
