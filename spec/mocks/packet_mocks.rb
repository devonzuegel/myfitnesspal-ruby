require 'binary/packet'

module PacketMocks
  # Contains mocks for raw packets of each type
  module Raw
    HEADER = [
      [Binary::Packet::MAGIC].pack('s>'),
      [2].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>'),
      [20].pack('l>')
    ]

    SYNC_REQUEST = [
      *HEADER,
      [2].pack('l>'), # api_version
      [4].pack('l>'), # svn_revision
      [2].pack('l>'), # unknown1
      'username', # username
      'password', # password
      [2].pack('l>'), # flags
      'this_is_a_uuid', # installation_uuid
      {}, # last_sync_pointers
    ].join

    BAD_MAGIC = [
      [1].pack('s>'),
      [500].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>')
    ].join
  end

  # Contains mocks for json-serialized packets of each type
  module Json
    SYNC_REQUEST = {
      packet_type:        1,
      packet_start:       0,
      packet_length:      30,
      api_version:        6,
      svn_revision:       237,
      unknown1:           2,
      username:           '',
      password:           '',
      flags:              5,
      installation_uuid:  'sample_uuid',
      last_sync_pointers: {}
    }
  end
end