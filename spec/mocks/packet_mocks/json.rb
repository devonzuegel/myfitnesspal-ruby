require 'binary/packet'

module PacketMocks
  # Contains mocks for json-serialized packets of each type
  module Json
    SYNC_REQUEST_DEFAULT = {
      api_version:        6,
      svn_revision:       237,
      unknown1:           2,
      username:           '',
      password:           '',
      flags:              0x5,
      installation_uuid:  SecureRandom.uuid,
      last_sync_pointers: 'last_sync_pointers'
    }.freeze

    SYNC_REQUEST_UPDATED = SYNC_REQUEST_DEFAULT.merge(
      api_version:        1,
      svn_revision:       1,
      unknown1:           1,
      flags:              1,
      username:           'hello_world',
      password:           'hello_world',
      installation_uuid:  'this_is_a_uuid',
      last_sync_pointers: 'codec_map'
    )
  end
end
