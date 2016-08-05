require 'binary/packet'
require 'binary/type'

module MFP
  module Binary
    class DeleteItem < Packet
      PACKET_TYPE = Type::DELETE_ITEM

      def initialize
        super(PACKET_TYPE)
      end

      def to_h
        super.merge(
          item_type:    @item_type,
          master_id:    @master_id,
          status:       @status,
          is_destroyed: @status == 2
        )
      end

      def set_default_values
        @item_type    = 0
        @master_id    = 0
        @status       = 0
        @is_destroyed = 0
      end

      def read_body_from_codec(codec)
        @item_type = codec.read_2_byte_int
        @master_id = codec.read_8_byte_int
        @status    = codec.read_2_byte_int
      end
    end
  end
end
