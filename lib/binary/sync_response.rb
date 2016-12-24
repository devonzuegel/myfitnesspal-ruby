require_relative 'packet'
require_relative 'type'

module MFP
  module Binary
    class SyncResponse < Binary::Packet
      PACKET_TYPE = Binary::Type::SYNC_RESPONSE

      attr_reader :last_sync_pointers

      def initialize
        super(PACKET_TYPE)
      end

      def to_h
        super.merge(
          status_code:            @status_code,
          status_message:         status_message,
          error_message:          @error_message,
          optional_extra_message: @optional_extra_message,
          master_id:              @master_id,
          flags:                  @flags,
          expected_packet_count:  @expected_packet_count,
          last_sync_pointers:     @last_sync_pointers,
          more_data_to_sync:      @more_data_to_sync,
          upgrade_available:      @upgrade_available,
          upgrade_alert:          @upgrade_alert,
          upgrade_url:            @upgrade_url
        )
      end

      def set_default_values
        @status_code            = 0
        @error_message          = ''
        @optional_extra_message = ''
        @master_id              = 0
        @flags                  = 0
        @expected_packet_count  = 0
        @last_sync_pointers     = {}
        @more_data_to_sync      = 0x1 # Flag('flags', 0x1) # TODO implement flags
        @upgrade_available      = 0x2 # Flag('flags', 0x2) # TODO implement flags
      end

      def read_body_from_codec(codec)
        @status_code            = codec.read_2_byte_int
        @error_message          = codec.read_string
        @optional_extra_message = codec.read_string
        @master_id              = codec.read_4_byte_int
        @flags                  = codec.read_2_byte_int
        last_sync_pointer_count = codec.read_2_byte_int
        @expected_packet_count  = codec.read_4_byte_int
        @last_sync_pointers     = codec.read_map(
          count:    last_sync_pointer_count,
          read_key: -> { codec.read_string }
        )
      end

      def status_message
        STATUS_MSGS[@status_code]
      end

      def status_message=(value)
        unless STATUS_MSGS.keys.include?(value)
          fail ValueError "Unknown status message #{value}"
        end
      end

      def success?
        status_code.zero?
      end

      private

      attr_reader :status_code

      STATUS_MSGS =
        {
          0 => 'Authenticated successfully',
          1 => 'Invalid registration',
          2 => 'Authentication failed',
        }.freeze
      private_constant(:STATUS_MSGS)
    end
  end
end
