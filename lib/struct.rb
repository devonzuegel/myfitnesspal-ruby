# Interpret strings as packed binary data.
class Struct
  def self.parse(str, num_bytes, pack_directive)
    bytes = str.slice(0, num_bytes)
    rest  = str.slice(num_bytes, str.length)

    fail EOFError if bytes.length < num_bytes

    [
      *bytes.unpack(pack_directive),
      rest
    ]
  end

  def self.pack_short(val)
    [val].pack('s>')
  end

  def self.pack_long(val)
    [val].pack('l>')
  end

  def self.pack_string(str)
    [
      [str.length].pack('s>'),
      str
    ].join
  end

  def self.pack_hash(hash, key_type: 'short')
    result = [
      [hash.keys.length].pack('s>')
    ]


    hash.each do |key, value|
      result += [
        pack_method(key_type).call(key),
        pack_string(value)
      ]
    end

    result.join
  end

  def self.pack_method(key_type)
    case key_type.downcase
      when 'short'  then -> (val) { pack_short(val)  }
      when 'long'   then -> (val) { pack_long(val)   }
      when 'string' then -> (val) { pack_string(val) }
      else fail NotImplementedError
    end
  end
end
