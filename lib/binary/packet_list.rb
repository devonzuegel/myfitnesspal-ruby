require 'concord'

module Binary
  class PacketList
    include Concord.new(:raw), Enumerable

    attr_reader :raw

    def each
      all.each { |packet| yield packet }
    end

    def all
      parsed_packets = []
      loop do
        parsed_packets += Codec.new(raw).packets
        break
      end
      parsed_packets
    end
  end
end
