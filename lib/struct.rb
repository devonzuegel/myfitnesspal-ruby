# Interpret strings as packed binary data.
module MFP
  module Struct
    def self.parse(str, num_bytes, pack_directive)
      fail EOFError if str.length < num_bytes

      unpacked, = str.unpack(pack_directive)
      rest      = str.slice(num_bytes, str.length)

      [unpacked, rest]
    end

    def self.pack_short(val)
      [val].pack('s>')
    end

    def self.pack_long(val)
      [val].pack('l>')
    end

    def self.pack_string(str)
      [pack_short(str.length), str].join
    end

    def self.pack_hash(hash, pack_key: -> (val) { pack_short(val) })
      packed =
        hash.map do |key, value|
          [pack_key.call(key), pack_string(value)]
        end

      [pack_short(hash.length), packed].join
    end
  end
end

