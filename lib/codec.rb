require 'anima'
require 'struct'

require 'binary/type'
require 'binary/packet'
require 'binary/sync_request'
require 'binary/sync_response'
require 'binary/user_property_update'
require 'binary/measurement_types'
require 'binary/food'
require 'binary/meal_ingredients'
require 'binary/food_entry'
require 'binary/exercise'

# Encodes and decodes MyFitnessPal binary objects.
class Codec
  include Anima.new(:original_str, :remainder, :expected_packet_count)

  def initialize(original_str)
    super(
      original_str:          original_str,
      remainder:             original_str,
      expected_packet_count: nil
    )
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

  def read_packet(raw_packet)
    type   = retrieve_type(raw_packet)
    packet = Binary::Type.supported_types.fetch(type).new
    packet.read_body_from_codec(Codec.new(raw_packet.fetch(:body)))
    packet
  end

  def each_packet
    packets.each { |packet| yield packet }
  end

  def packets
    raw_packets.map { |raw_packet| read_packet(raw_packet) }
  end

  def read_packet_header
    {
      magic_number: read_magic_number,
      length:       read_4_byte_int,
      unknown1:     read_2_byte_int,
      type:         read_2_byte_int
    }
  end

  def read_map(count: nil, read_key: -> { read_2_byte_int }, read_value: -> { read_string })
    count ||= read_2_byte_int
    count.times.map { [read_key.call, read_value.call] }.to_h
  end

  def read_2_byte_int
    read_bytes(2, 's>')
  end

  def read_4_byte_int
    read_bytes(4, 'l>')
  end

  def read_8_byte_int
    read_bytes(8, 'q>')
  end

  def read_float
    read_bytes(4, 'g')
  end

  def read_date
    unparsed_date = remainder.slice(0, Binary::Packet::DATE_SIZE)
    @remainder = remainder.slice(Binary::Packet::DATE_SIZE, remainder.length)
    Date.iso8601(unparsed_date)
  end

  def read_uuid
    read_string(Binary::Packet::UUID_LENGTH)
  end

  def read_string(str_length = nil)
    str_length ||= read_2_byte_int
    str, @remainder = split(remainder, str_length)
    str
  end

  private

  def split(str, str1_len)
    str1 = str.slice(0, str1_len)
    str2 = str.slice(str1_len, str.length) || ''
    [str1, str2]
  end

  def read_bytes(n_bytes, pack_directive)
    bytes, @remainder = Struct.parse(remainder, n_bytes, pack_directive)
    bytes
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
end
