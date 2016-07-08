require 'anima'
require 'struct'
require 'colorize'
require 'awesome_print'

require 'binary/type'
require 'binary/packet'
require 'binary/sync_request'
require 'binary/sync_response'
require 'binary/user_property_update'
require 'binary/measurement_types'
require 'binary/food'
require 'binary/meal_ingredients'
require 'binary/food_entry'

# Encodes and decodes MyFitnessPal binary objects.
class Codec
  include Anima.new(
    :original_str,
    :remainder,
    :expected_packet_count,
    :packet_count
  )

  UUID_LENGTH        = 16
  PACKET_HEADER_SIZE = 10

  def initialize(original_str)
    super(
      original_str:          original_str,
      remainder:             original_str,
      expected_packet_count: nil,
      packet_count:          0
    )
  end

  def read_packet
    type               = packet_header.fetch(:type)
    body_length        = packet_header.fetch(:length) - PACKET_HEADER_SIZE
    expected_remainder = remainder.slice(body_length, remainder.length)

    fail NotImplementedError, "Type #{type} is not supported" unless Binary::Type.supported_types.include?(type)
    # puts "Type #{type}: #{Binary::Type.supported_types.fetch(type)}".black

    klass  = Binary::Type.supported_types.fetch(type)
    packet = klass.new(packet_header.fetch(:length))
    # puts "#{packet.to_h}".blue

    packet.read_body_from_codec(self)
    update_packet_count(packet)

    check_unexpected_remainder!(expected_remainder)

    @header = nil
    [remainder.empty?, packet]
  end

  def read_map(count: nil, read_key: -> { read_2_byte_int }, read_value: -> { read_string })
    count ||= read_2_byte_int
    items = {}

    count.times do
      key        = read_key.call
      value      = read_value.call
      items[key] = value
    end

    items
  end

  def read_packets
    loop do
      eof, packet = read_packet
      yield packet
      break if eof
    end
    check_packet_count!
    @remainder = original_str # Reset for future read
  end

  def packet_header
    @header ||= {
      magic_number: read_2_byte_int,
      length:       read_4_byte_int,
      unknown1:     read_2_byte_int,
      type:         read_2_byte_int
    }
    check_magic_number!(@header.fetch(:magic_number))
    @header
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
    length_of_date = 10
    unparsed_date = remainder.slice(0, length_of_date)
    @remainder = remainder.slice(length_of_date, remainder.length)
    Date::iso8601(unparsed_date)
  end

  def read_uuid
    read_string(UUID_LENGTH)
  end

  def read_string(str_length = nil)
    str_length ||= read_2_byte_int
    str          = remainder.slice(0, str_length)
    @remainder   = remainder.slice(str_length, remainder.length)

    str
  end

  private

  def check_packet_count!
    return if expected_packet_count.nil? || expected_packet_count == packet_count

    msg = "Expected #{expected_packet_count} objects, received #{packet_count}"
    fail TypeError, msg
  end

  def read_bytes(n_bytes, pack_directive)
    bytes, @remainder = Struct.parse(remainder, n_bytes, pack_directive)
    bytes
  end

  def update_packet_count(packet)
    if packet.class == Binary::SyncResponse
      @expected_packet_count = packet.expected_packet_count
    else
      @packet_count += 1
    end
  end

  def check_unexpected_remainder!(expected_remainder)
    return# if remainder == expected_remainder

    puts "TODO!!!!!!!!".red
    message = <<-HEREDOC
      Packet read finished with remainder "#{remainder.length}", but expected it to
      to be "#{expected_remainder.length}"
    HEREDOC

    # Pathname.new(__dir__)
    #   .join('../spec/fixtures/remainder.bin')
    #   .expand_path
    #   .write(remainder.slice(0, 1000))

    fail TypeError, message
  end

  def check_magic_number!(magic_number)
    return if magic_number == Binary::Packet::MAGIC
    fail TypeError, "Unexpected magic number #{magic_number}"
  end
end
