module PacketMocks
  module Fixture
    SYNC_REQUEST =
      Pathname.new(__dir__)
        .join('fixtures/sync_request.bin')
        .expand_path
        .read
        .force_encoding('ASCII-8BIT')
  end
end
