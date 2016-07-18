# Pack data into binary format.
module MFP
  module Struct
    module Packer
      def pack_short(val)
        [val].pack('s>')
      end

      def pack_long(val)
        [val].pack('l>')
      end

      def pack_string(str)
        [pack_short(str.length), str].join
      end

      def pack_hash(hash, pack_key: -> (val) { pack_short(val) })
        packed =
          hash.map do |key, value|
            [pack_key.call(key), pack_string(value)]
          end

        [pack_short(hash.length), packed].join
      end
    end
  end
end
