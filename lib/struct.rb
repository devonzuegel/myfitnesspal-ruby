# Interpret strings as packed binary data.
class Struct
  def self.parse(str, num_bytes, pack_directive)
    bytes = str[0..num_bytes]
    rest  = str[num_bytes..str.length]

    fail EOFError if bytes.length < num_bytes

    [
      *bytes.unpack(pack_directive),
      rest
    ]
  end
end
