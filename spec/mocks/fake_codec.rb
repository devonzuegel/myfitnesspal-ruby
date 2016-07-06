# Mock for Codec
class FakeCodec
  def position
    1
  end

  def write_string(str = '')
  end

  def write_uuid(uuid)
  end

  def write_2_byte_int(val)
  end

  def write_4_byte_int(val)
  end

  def temporary_position(val)
    val
  end

  def read_4_byte_int
    1
  end

  def read_2_byte_int
    1
  end

  def read_string
    'hello_world'
  end

  def read_uuid
    Binary::Packet.generate_uuid
  end

  def read_map(_int)
    {
      'key1' => 'value1',
      'key2' => 'value2'
    }
  end

  def write_map(_int, _str1, _str2)
    fail NotImplementedError
  end
end