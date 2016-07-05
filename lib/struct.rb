# Interpret strings as packed binary data.
class Struct
  def self.read_bytes(str, index: 0, num_bytes:)
    bytes = str.byteslice(index, num_bytes)
    fail EOFError if bytes.length < num_bytes
    bytes
  end
end
