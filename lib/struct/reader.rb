require 'anima'

# Interpret strings as packed binary data.
module MFP
  module Struct
    module Reader
      def read_date(str)
        date_str, remainder = split(str, Binary::Packet::DATE_SIZE)
        [Date.iso8601(date_str), remainder]
      end

      def read_2_byte_int
        parse(2, 's>')
      end

      def read_4_byte_int
        parse(4, 'l>')
      end

      def read_8_byte_int
        parse(8, 'q>')
      end

      def read_float
        parse(4, 'g')
      end

      def read_map(count: nil, read_key: -> { read_2_byte_int }, read_value: -> { read_string })
        count ||= read_2_byte_int
        Array.new(count) { [read_key.call, read_value.call] }.to_h
      end

      def read_uuid
        read_string(Binary::Packet::UUID_LENGTH)
      end

      def read_string(str_length = nil)
        str_length ||= read_2_byte_int
        str, @remainder = split(remainder, str_length)
        str
      end

      def parse(str, num_bytes, pack_directive)
        fail EOFError if str.length < num_bytes

        unpacked, = str.unpack(pack_directive)
        rest      = str.slice(num_bytes, str.length)

        [unpacked, rest]
      end

      private

      attr_reader :remainder

      def split(str, str1_len)
        [
          str.slice(0, str1_len),
          str.slice(str1_len, str.length) || ''
        ]
      end
    end
  end
end
