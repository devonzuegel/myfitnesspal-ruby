require 'codec'
require 'binary/packet'

module PacketMocks
  # Contains mocks for deserialized packets of each type
  module Hash
    SYNC_REQUEST_DEFAULT = {
      packet_type:        1,
      api_version:        6,
      svn_revision:       237,
      unknown1:           2,
      username:           '',
      password:           '',
      flags:              0x5,
      installation_uuid:  MFP::Binary::Packet.generate_uuid,
      last_sync_pointers: {}
    }.freeze

    SYNC_REQUEST_UPDATED = SYNC_REQUEST_DEFAULT.merge(
      api_version:        1,
      svn_revision:       1,
      unknown1:           1,
      flags:              1,
      username:           'hello_world',
      password:           'hello_world',
      last_sync_pointers: {
        'key1' => 'value1',
        'key2' => 'value2'
      }
    )
  end
end
