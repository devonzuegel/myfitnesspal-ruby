require 'bundler/setup'
require 'abstract_method'

require 'binary/type'

module Binary
  class SyncResult < Binary::Packet
    PACKET_TYPE = Binary::Type::SYNC_RESULT
  end

  def set_default_values
    @status_code            = 0
    @error_message          = ''
    @optional_extra_message = ''
    @master_id              = 0
    @flags                  = 0
    @expected_packet_count  = 0
    @last_sync_pointers     = {}
    @more_data_to_sync      = Flag('flags', 0x1)
    @upgrade_available      = Flag('flags', 0x2)
  end

  def status_message
    status_messages[@status_code]
  end

  def status_message=(value)
    unless status_messages.keys.include?(value)
      fail ValueError "Unknown status message #{value}"
    end


  end

  private

  def status_messages
    defined_messages = {
      0 => 'ok',
      1 => 'invalid_registration',
      2 => 'authentication_failed'
    }
    defined_messages.default = 'unknown'
    defined_messages
  end
end
