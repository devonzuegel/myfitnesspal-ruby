require 'binary/packet'

module PacketMocks
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
    private_class_method(:body_from_json)

    def self.headers_from_json(attrs, length)
      [
        PACKED_MAGIC,
        [length].pack('l>'),
        [attrs.fetch(:unknown1)].pack('s>'),
        [attrs.fetch(:packet_type)].pack('s>')
      ].join
    end
    private_class_method(:headers_from_json)
  end
end
