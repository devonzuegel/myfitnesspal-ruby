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

  # Contains mocks for raw packets of each type
  module Raw
    BAD_HEADER = [
      [1].pack('s>'),
      [500].pack('l>'),
      [1].pack('s>'),
      [1].pack('s>')
    ].join

    PACKED_MAGIC = [Binary::Packet::MAGIC].pack('s>')

    def self.from_json(json)
      body    = body_from_json(json)
      headers = headers_from_json(json, body.length)
      "#{headers}#{body}"
    end

    def self.sync_request
      from_json(PacketMocks::Json::SYNC_REQUEST_DEFAULT.merge(packet_type: 1))
    end

    def self.body_from_json(attrs)
      username = 'original_username'
      password = 'original_password'
      uuid     = 'sample_uuid'

      [
        [attrs.fetch(:api_version)].pack('s>'),
        [attrs.fetch(:svn_revision)].pack('l>'),
        [attrs.fetch(:unknown1)].pack('s>'),
        "#{[username.length].pack('s>')}#{username}",
        "#{[password.length].pack('s>')}#{password}",
        [attrs.fetch(:flags)].pack('s>'),
        "#{[uuid.length].pack('s>')}#{uuid}",
        'old_last_sync_pointers'
      ].join
    end

    def self.headers_from_json(attrs, length)
      [
        PACKED_MAGIC,
        [length].pack('l>'),
        [attrs.fetch(:unknown1)].pack('s>'),
        [attrs.fetch(:packet_type)].pack('s>')
      ].join
    end

    private_class_method(:body_from_json)
    private_class_method(:headers_from_json)
  end
end
