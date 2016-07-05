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

  # def foo
  #   @position += 1
  # end
end
